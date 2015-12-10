feature 'ノマゲ地力表' do
  given(:user) { create(:user, id: 1) }
  background do
    visit sheet_path(iidxid: user.iidxid, type: 'clear')
    wait_for_ajax
  end

  scenario '存在しないユーザへのアクセス' do
    visit sheet_path(iidxid: '1111-1111', type: 'clear')
    wait_for_ajax
    expect(page).to have_content('このページは存在しません')
  end

  context 'ログイン時' do
    background { login(user) }
    scenario 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD', sheet_path(iidxid: user.iidxid, type: 'hard'))
    end
  end

  context '非ログイン時' do
    scenario 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD', sheet_path(iidxid: user.iidxid, type: 'hard'))
    end
  end
end
