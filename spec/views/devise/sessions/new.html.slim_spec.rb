RSpec.describe 'devise/sessions/new.html.slim', type: :view do
  before do
    create(:user, id: 1)
    visit new_user_session_path
  end
  let(:user) { User.find_by(id: 1) }
  context 'iidxidでログイン' do
    it 'response ok' do
      fill_in 'user_login', with: user.iidxid
      fill_in 'user_password', with: 'hogehoge'
      click_button 'ログイン'
      within first(:xpath, 'html') do
        expect(page).to have_content('マイページ')
      end
    end
  end

  context 'usernameでログイン' do
    it 'response ok' do
      fill_in 'user_login', with: user.username
      fill_in 'user_password', with: 'hogehoge'
      click_button 'ログイン'
      within first(:xpath, 'html') do
        expect(page).to have_content('マイページ')
      end
    end
  end
end
