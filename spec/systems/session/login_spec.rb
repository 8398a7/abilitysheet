# frozen_string_literal: true

feature 'ログイン処理', type: :system do
  background do
    create(:user, id: 1)
    visit new_user_session_path
  end
  given(:user) { User.find_by(id: 1) }
  context 'iidxidでログイン' do
    scenario 'response ok' do
      fill_in 'user_login', with: user.iidxid
      fill_in 'user_password', with: 'hogehoge'
      click_button 'ログイン'
      within first(:xpath, 'html') do
        expect(page).to have_content('マイページ')
      end
    end
  end

  context 'usernameでログイン' do
    scenario 'response ok' do
      fill_in 'user_login', with: user.username
      fill_in 'user_password', with: 'hogehoge'
      click_button 'ログイン'
      within first(:xpath, 'html') do
        expect(page).to have_content('マイページ')
      end
    end
  end
end
