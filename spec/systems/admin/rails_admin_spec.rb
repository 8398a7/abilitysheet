# frozen_string_literal: true

feature RailsAdmin, type: :system do
  given(:user) { create(:user, id: 1) }
  background { login(user) }

  context '管理者の場合' do
    background do
      user.update!(role: 100)
      visit rails_admin_path
    end

    scenario '管理者ページが閲覧できる' do
      expect(page).to have_content('サイト管理')
    end
  end
end
