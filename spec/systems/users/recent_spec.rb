# frozen_string_literal: true

feature '最近更新したユーザ200人一覧', type: :system, js: true do
  let(:iidxid) { '0000-0000' }
  background do
    create(:user, id: 1, iidxid: iidxid)
    create(:sheet, id: 1)
    create(:score, user_id: 1, sheet_id: 1, state: 5)
    visit users_path
  end

  scenario 'プロフィールページへのリンクが存在する' do
    expect(page).to have_link('TEST')
  end

  context 'IIDXID検索時' do
    scenario '該当件数が0であること返す' do
      fill_in 'query', with: '0000-0001'
      click_button '検索'
      expect(page).to have_content('No data available in table')
    end
    scenario '完全一致で該当するユーザを返す' do
      fill_in 'query', with: iidxid
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
  end
end
