# frozen_string_literal: true

feature '地力値表', type: :system, js: true do
  given(:user) { create(:user, id: 1) }
  background do
    create(:score, user_id: 1, sheet_id: 1)
    visit recommends_path
  end

  context 'ログイン時' do
    background do
      login(user)
      visit recommends_path
    end
    scenario '地力値表が表示できる' do
      expect(page).to have_content('TITLE')
    end
  end

  context '非ログイン時' do
    scenario '地力値表が表示できる' do
      expect(page).to have_content('TITLE')
    end
  end
end
