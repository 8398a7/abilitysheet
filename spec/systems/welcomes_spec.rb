# frozen_string_literal: true

feature 'トップページ', type: :system, js: true do
  given(:user) { create(:user, id: 1) }
  context 'ログイン時' do
    scenario 'デラレコの新規登録ボタンが表示されていない' do
      login(user)
      visit root_path
      expect(page).to have_no_link('デラレコで新規登録', href: 'https://record.iidx.app/')
    end
  end

  context '非ログイン時' do
    scenario 'デラレコの新規登録ボタンが表示されている' do
      visit root_path
      expect(page).to have_link('デラレコで新規登録', href: 'https://record.iidx.app/')
      expect(page).to have_no_link(href: new_user_registration_path)
    end
  end
end
