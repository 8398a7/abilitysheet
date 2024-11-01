# frozen_string_literal: true

feature 'ダッシュボードの閲覧', type: :system do
  background do
    user = create(:user, id: 1)
    user.add_role(:admin)
    login(user)
    visit admin_dashboards_path
  end

  it 'email登録人数が見れる' do
    expect(page).to have_content('email登録人数')
  end
  it '未読メッセージが見れる' do
    expect(page).to have_content('未読メッセージ')
    expect(page).to have_content('0件')
  end
end
