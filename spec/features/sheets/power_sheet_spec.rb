feature '地力値表' do
  given(:user) { create(:user, id: 1) }
  background  do
    visit sheet_path(iidxid: user.iidxid, type: 'power')
    wait_for_ajax
  end

  scenario '存在しないユーザへのアクセス' do
    visit sheet_path(iidxid: '1111-1111', type: 'power')
    expect(page).to have_content('このページは存在しません')
  end

  context 'ログイン時' do
    background { login(user) }
    scenario 'iidx.meの文字が存在する' do
      expect(page).to have_content('iidx.me')
    end
  end

  context '非ログイン時' do
    scenario 'iidx.meの文字が存在する' do
      expect(page).to have_content('iidx.me')
    end
  end
end
