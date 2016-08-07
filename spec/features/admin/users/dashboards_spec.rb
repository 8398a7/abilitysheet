# frozen_string_literal: true
feature 'ダッシュボードの閲覧' do
  background do
    create(:user, id: 1, role: 100)
    login(User.find(1))
    visit admin_dashboards_path
  end

  it 'sidekiqの状態が見れる' do
    expect(page).to have_content('sidekiq')
    expect(page).to have_content('inactive')
  end
  it 'email登録人数が見れる' do
    expect(page).to have_content('email登録人数')
  end
  it '未読メッセージが見れる' do
    expect(page).to have_content('未読メッセージ')
    expect(page).to have_content('0件')
  end
  it 'used memoryが見れる' do
    expect(page).to have_content('used memory')
  end
  it 'margin memoryが見れる' do
    expect(page).to have_content('margin memory')
  end
end
