feature '最近更新したユーザ200人一覧' do
  given(:user) { create(:user, id: 1) }
  background do
    create(:score, user_id: 1, sheet_id: 1)
    visit users_path
  end

  context 'DJNAME検索時', js: true do
    background { create(:user, id: 1) }
    scenario '該当件数が0であること返す' do
      fill_in 'query', with: 'HOGE'
      click_button '検索'
      expect(page).to have_content('No data available in table')
    end
    scenario '完全一致で該当するユーザを返す' do
      fill_in 'query', with: 'TEST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '前方一致で該当するユーザを返す' do
      fill_in 'query', with: 'TE'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '中間一致で該当するユーザを返す' do
      fill_in 'query', with: 'ES'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '後方一致で該当するユーザを返す' do
      fill_in 'query', with: 'ST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
  end

  context 'ログイン時' do
    background do
      login(user)
      visit users_path
    end
    scenario 'ライバルのカラムが存在する' do
      expect(page).to have_content('ライバル情報')
    end
  end

  context '非ログイン時' do
    scenario 'ライバルのカラムが存在しない' do
      expect(page.has_content?('ライバル情報')).to eq false
    end
  end
end
