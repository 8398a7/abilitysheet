feature 'Navbarの閲覧可能コンテンツ', js: true do
  context 'ログインしていない場合' do
    background do
      visit root_path
      wait_for_ajax
    end
    scenario '管理項目が表示されていない' do
      expect(page).to have_no_css('.admin-parent')
    end
  end
  context 'Role::GENERALでログインしている場合' do
    background do
      user = create(:user, role: User::Role::GENERAL)
      login(user)
      visit root_path
      wait_for_ajax
    end
    scenario '管理項目が表示されていない' do
      expect(page).to have_no_css('.admin-parent')
    end
  end
  context 'Role::OWNERでログインしている場合' do
    background do
      user = create(:user, role: User::Role::OWNER)
      login(user)
      visit root_path
      wait_for_ajax
    end
    scenario '管理項目が表示されている' do
      expect(page).to have_css('.admin-parent')
    end
  end
end
