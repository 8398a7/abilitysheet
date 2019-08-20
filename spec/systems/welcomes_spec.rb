# frozen_string_literal: true

feature 'トップページ', type: :system, js: true do
  given(:user) { create(:user, id: 1) }
  context 'ログイン時' do
    scenario '登録ボタンが表示されていない' do
      login(user)
      visit root_path
      expect(page).to have_no_content('登録')
    end
  end

  context '非ログイン時' do
    scenario '登録ボタンが表示されている' do
      visit root_path
      expect(page).to have_content('登録')
    end
  end
end
