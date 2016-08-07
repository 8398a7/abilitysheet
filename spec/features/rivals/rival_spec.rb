# frozen_string_literal: true
feature 'ライバル情報' do
  given(:user) { create(:user, id: 1) }
  background do
    user2 = create(:user, id: 2, djname: 'RIVAL', iidxid: '1111-1111', username: 'rival')
    user.follow(user2.iidxid)
    login(user)
  end

  scenario 'プロフィールページへのリンクが存在する', js: true do
    visit list_rival_path
    wait_for_ajax
    expect(page).to have_link('RIVAL')
  end

  scenario '楽曲情報が正しくロードされている' do
    sync_sheet
    visit clear_rival_path(user.iidxid)
    expect(page).to have_selector('td[@name="music"]', count: Sheet.active.count)
    click_link 'Win'
    expect(page).to have_selector('td[@name="music"]', count: 0)
    click_link 'Even'
    expect(page).to have_selector('td[@name="music"]', count: Sheet.active.count)
    click_link 'Lose'
    expect(page).to have_selector('td[@name="music"]', count: 0)
    click_link 'ALL'
    expect(page).to have_selector('td[@name="music"]', count: Sheet.active.count)
  end
end
