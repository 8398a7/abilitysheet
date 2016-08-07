# frozen_string_literal: true
feature '連絡フォーム' do
  given(:user) { create(:user, id: 1) }
  background do
    create(:score, user_id: 1, sheet_id: 1)
    visit new_message_path
  end

  context 'ログイン時' do
    background do
      login(user)
      visit new_message_path
    end
    scenario '連絡フォームが正しく表示できる' do
      expect(page).to have_content('連絡フォーム')
    end
  end

  context '非ログイン時' do
    scenario '連絡フォームが正しく表示できる' do
      expect(page).to have_content('連絡フォーム')
    end
  end
end
