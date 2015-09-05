RSpec.describe 'users/index.html.slim', type: :view do
  let(:user) { create(:user, id: 1) }
  before do
    create(:score, user_id: 1, sheet_id: 1)
    visit users_path
  end

  context 'DJNAME検索時', js: true do
    before { create(:user, id: 1) }
    it '該当件数が0であること返す' do
      fill_in 'query', with: 'HOGE'
      click_button '検索'
      expect(page).to have_content('No data available in table')
    end
    it '完全一致で該当するユーザを返す' do
      fill_in 'query', with: 'TEST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    it '前方一致で該当するユーザを返す' do
      fill_in 'query', with: 'TE'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    it '中間一致で該当するユーザを返す' do
      fill_in 'query', with: 'ES'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
    it '後方一致で該当するユーザを返す' do
      fill_in 'query', with: 'ST'
      click_button '検索'
      expect(page).to have_content('Showing 1 to 1 of 1 entries')
    end
  end

  context 'ログイン時' do
    before do
      login_as(user, scope: :user, run_callbacks: false)
      visit users_path
    end
    it 'ライバルのカラムが存在する' do
      expect(page).to have_content('ライバル情報')
    end
  end

  context '非ログイン時' do
    it 'ライバルのカラムが存在しない' do
      expect(page.has_content?('ライバル情報')).to eq false
    end
  end
end
