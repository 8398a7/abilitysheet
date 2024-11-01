# frozen_string_literal: true

feature 'ログの詳細画面', type: :system, js: true do
  background do
    @user = create(:user, id: 1, iidxid: '1234-5678')
    create(:sheet, id: 1, title: 'log spec1')
    create(:sheet, id: 2, title: 'log spec2')
    create(:score, sheet_id: 1, state: 6, user_id: 1)
    create(:score, sheet_id: 2, state: 6, user_id: 1)
    create(:log, sheet_id: 1, user_id: 1, created_date: Date.today, pre_state: 7, new_state: 6)
    create(:log, sheet_id: 2, user_id: 1, created_date: Date.today, pre_state: 7, new_state: 6)
    visit logs_path(@user.iidxid, Date.today.to_s)
  end

  scenario 'ログが存在する' do
    expect(page).to have_content('log spec1')
    expect(page).to have_content('log spec2')
  end

  context 'ログイン時' do
    background { login(@user) }
    context '自分のログページの場合' do
      scenario 'ログ編集ボタンのリンクが存在する' do
        visit logs_path(@user.iidxid, Date.today.to_s)
        expect(page).to have_link('log spec1')
      end
      scenario '削除ボタンが存在する' do
        visit logs_path(@user.iidxid, Date.today.to_s)
        click_button '表示'
        expect(page).to have_content('削除')
      end
      scenario 'ログが削除できる' do
        expect(Log.where(user_id: @user.id).count).to eq 2
        expect(Score.exists?(user_id: @user.id, state: 7)).to eq false
        visit logs_path(@user.iidxid, Date.today.to_s)
        click_button '表示'
        click_link '削除', match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('ログを削除し')
        expect(Log.where(user_id: @user.id).count).to eq 1
        expect(Score.exists?(user_id: @user.id, state: 7)).to eq true
      end
      scenario 'ログが0個になったら一覧に遷移する' do
        visit logs_path(@user.iidxid, Date.today.to_s)
        click_button '表示'
        click_link '削除', match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('ログを削除し')
        click_button '表示'
        click_link '削除', match: :first
        page.driver.browser.switch_to.alert.accept
        sleep 5
        expect(page).to have_content('更新履歴')
      end
    end
    context '他人のログページの場合' do
      background do
        @user2 = create(:user, id: 2, username: 'user2', iidxid: '2234-5678')
        create(:score, sheet_id: 1, state: 6, user_id: 2)
        create(:score, sheet_id: 2, state: 6, user_id: 2)
        create(:log, sheet_id: 1, user_id: 2, created_date: Date.today, pre_state: 7, new_state: 6)
        create(:log, sheet_id: 2, user_id: 2, created_date: Date.today, pre_state: 7, new_state: 6)
        visit logs_path(@user2.iidxid, Date.today.to_s)
      end
      scenario 'ログ編集ボタンのリンクが存在しない' do
        expect(page).to have_no_link('log spec1')
      end
      context 'ロールなしの場合' do
        scenario '削除ボタンが存在しない' do
          expect(page).to have_no_content('削除')
        end
      end
      context 'adminの場合' do
        background do
          @user.add_role(:admin)
          visit logs_path(@user2.iidxid, Date.today.to_s)
        end
        scenario '削除ボタンが存在する' do
          click_button '表示'
          expect(page).to have_content('削除')
        end
        scenario 'ログが削除できる' do
          expect(Log.where(user_id: @user2.id).count).to eq 2
          expect(Score.exists?(user_id: @user2.id, state: 7)).to eq false
          click_button '表示'
          click_link '削除', match: :first
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content('ログを削除し')
          expect(Log.where(user_id: @user2.id).count).to eq 1
          expect(Score.exists?(user_id: @user2.id, state: 7)).to eq true
        end
      end
    end
  end

  context '非ログイン時' do
    scenario '削除ボタンが存在しない' do
      expect(page).to have_no_content('削除')
    end
  end
end
