# frozen_string_literal: true

feature 'Navbarの閲覧可能コンテンツ', type: :system, js: true do
  context 'ログインしていない場合' do
    background do
      visit root_path
    end
    scenario '管理項目が表示されていない' do
      expect(page).to have_no_css('.admin-parent')
    end
    scenario 'ライバル欄が存在しない' do
      expect(page).to have_no_content('ライバル')
    end
  end
  context 'ログインしている場合' do
    background do
      user = create(:user)
      login(user)
      visit root_path
    end
    scenario '管理項目が表示されていない' do
      expect(page).to have_no_css('.admin-parent')
    end
    scenario 'ライバル欄が存在する' do
      expect(page).to have_content('ライバル')
    end
  end
  context '管理者でログインしている場合' do
    background do
      user = create(:user)
      user.add_role(:admin)
      login(user)
      visit root_path
    end
    scenario '管理項目が表示されている' do
      expect(page).to have_css('.admin-parent')
    end
    scenario 'ライバル欄が存在する' do
      expect(page).to have_content('ライバル')
    end
  end
end
