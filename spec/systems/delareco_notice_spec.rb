# frozen_string_literal: true

feature 'デラレコへの移行案内', type: :system, js: true do
  given(:user) { create(:user) }
  given(:storage_key) { "abilitysheet:delareco-notice:v1:#{user.id}" }
  given(:one_day_ms) { 24 * 60 * 60 * 1000 }

  scenario '未ログインの場合は表示しない' do
    [root_path, ist_helps_path].each do |path|
      visit path
      expect(page).to have_no_css('#delareco-notice')
    end
  end

  scenario 'ログイン中はトップページとヘルプに継続サポートと早めの移行の案内を表示する' do
    login(user)

    [root_path, ist_helps_path].each do |path|
      visit path

      within "#delareco-notice[open][data-user-id='#{user.id}']" do
        expect(page).to have_content('参考表は、beatmania IIDX 34もサポートする予定ですが、楽曲の追加・更新などはあまり行わない予定です。')
        expect(page).to have_content('2026年9月12日以降に参考表で登録・更新されたデータは、デラレコに取り込まれていません。')
        expect(page).to have_content('デラレコへの早めの移行をおすすめします。')
        expect(page).to have_link('デラレコへ', href: 'https://record.iidx.app')
        expect(page).to have_link('移行されたアカウントについて（FAQ）', href: 'https://record.iidx.app/migration-faq')
      end
    end
  end

  scenario '折りたたみをページ遷移と再読み込み後も保持し、すぐに再展開できる' do
    login(user)
    visit root_path
    find('#delareco-notice summary').click

    expect(page).to have_css('#delareco-notice:not([open])')
    expect(page.evaluate_script('localStorage.getItem(arguments[0])', storage_key)).to be_present

    page.execute_script('window.abilitysheetNoticeNavigationMarker = true')
    click_link '最近更新したユーザ', match: :first
    expect(page).to have_current_path(users_path)
    expect(page.evaluate_script('window.abilitysheetNoticeNavigationMarker')).to eq(true)
    expect(page).to have_css('#delareco-notice:not([open])')

    page.refresh
    expect(page).to have_css('#delareco-notice:not([open])')

    find('#delareco-notice summary').click
    expect(page).to have_css('#delareco-notice[open]')
    expect(page).to have_link('デラレコへ', href: 'https://record.iidx.app')
    expect(page.evaluate_script('localStorage.getItem(arguments[0])', storage_key)).to be_nil

    page.refresh
    expect(page).to have_css('#delareco-notice[open]')
  end

  scenario '折りたたんでから24時間未満は閉じ、24時間経過後にタブへ戻ると再表示する' do
    login(user)
    visit root_path
    page.execute_script(<<~JS, storage_key, one_day_ms)
      window.abilitysheetNoticeNow = Date.now();
      Date.now = function() { return window.abilitysheetNoticeNow; };
      localStorage.setItem(arguments[0], String(window.abilitysheetNoticeNow - arguments[1] + 60000));
      document.dispatchEvent(new Event('turbolinks:load'));
    JS
    expect(page).to have_css('#delareco-notice:not([open])')

    page.execute_script(<<~JS)
      window.abilitysheetNoticeNow += 60000;
      document.dispatchEvent(new Event('visibilitychange'));
    JS
    expect(page).to have_css('#delareco-notice[open]')
  end

  scenario 'ページを開いたままでも24時間経過したら再表示する' do
    login(user)
    visit root_path
    page.execute_script(<<~JS, storage_key, one_day_ms)
      localStorage.setItem(arguments[0], String(Date.now() - arguments[1] + 1500));
      document.dispatchEvent(new Event('turbolinks:load'));
    JS
    expect(page).to have_css('#delareco-notice:not([open])')
    expect(page).to have_css('#delareco-notice[open]', wait: 5)
  end

  scenario '別タブでの折りたたみと再展開を反映する' do
    login(user)
    visit root_path
    page.execute_script(<<~JS, storage_key)
      localStorage.setItem(arguments[0], String(Date.now()));
      window.dispatchEvent(new StorageEvent('storage', { key: arguments[0], storageArea: localStorage }));
    JS
    expect(page).to have_css('#delareco-notice:not([open])')

    page.execute_script(<<~JS, storage_key)
      localStorage.removeItem(arguments[0]);
      window.dispatchEvent(new StorageEvent('storage', { key: arguments[0], storageArea: localStorage }));
    JS
    expect(page).to have_css('#delareco-notice[open]')
  end

  scenario '折りたたんだ状態はユーザーごとに保持する' do
    other_user = create(:user, username: 'otheruser', iidxid: '8765-4321')
    login(user)
    visit root_path
    find('#delareco-notice summary').click
    expect(page).to have_css('#delareco-notice:not([open])')

    logout(:user)
    login(other_user)
    visit root_path
    expect(page).to have_css("#delareco-notice[open][data-user-id='#{other_user.id}']")

    logout(:user)
    login(user)
    visit root_path
    expect(page).to have_css("#delareco-notice:not([open])[data-user-id='#{user.id}']")
  end
end
