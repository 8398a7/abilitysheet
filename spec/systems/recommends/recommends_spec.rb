# frozen_string_literal: true

feature '地力値表', type: :system, js: true do
  given(:user) { create(:user) }
  given(:sheet) { create(:sheet) }
  background do
    create(:score, user_id: user.id, sheet_id: sheet.id)
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
