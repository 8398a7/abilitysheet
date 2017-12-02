# frozen_string_literal: true

feature '最近更新したユーザ200人一覧', type: :system, js: true do
  background do
    create(:user, id: 1)
    create(:sheet, id: 1)
    create(:score, user_id: 1, sheet_id: 1, state: 5)
    visit users_path
  end

  scenario 'プロフィールページへのリンクが存在する' do
    expect(page).to have_link('TEST')
  end

  context 'DJNAME検索時' do
    scenario '該当件数が0であること返す' do
      fill_in 'query', with: 'HOGE'
      click_button '検索'
      expect(page).to have_content('No data available in table')
    end
    scenario '完全一致で該当するユーザを返す' do
      fill_in 'query', with: 'TEST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '前方一致で該当するユーザを返す' do
      fill_in 'query', with: 'TE'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '中間一致で該当するユーザを返す' do
      fill_in 'query', with: 'ES'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    scenario '後方一致で該当するユーザを返す' do
      fill_in 'query', with: 'ST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
  end
end
