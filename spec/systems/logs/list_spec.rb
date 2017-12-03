# frozen_string_literal: true

feature 'ログ一覧', type: :system do
  given(:user) { create(:user, id: 1) }
  background do
    login(user)
    visit list_log_path(user.iidxid)
  end
  scenario 'ログ一覧ページが閲覧できる' do
    expect(page).to have_content('更新履歴')
  end
end
