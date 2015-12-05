feature 'ハード地力表' do
  given(:user) { create(:user, id: 1) }
  background { visit sheet_path(iidxid: user.iidxid, type: 'hard') }

  scenario '存在しないユーザへのアクセス' do
    visit sheet_path(iidxid: '1111-1111', type: 'hard')
    expect(page).to have_content('このページは存在しません')
  end

  context 'ログイン時' do
    background { login(user) }
    scenario 'ハード参考表の文字が存在する' do
      expect(page).to have_content('ハード参考表')
    end
    scenario 'クリア参考表のリンクが存在する' do
      expect(page).to have_link('CLEAR', sheet_path(iidxid: user.iidxid, type: 'clear'))
    end
  end

  context '非ログイン時' do
    scenario 'ハード参考表の文字が存在する' do
      expect(page).to have_content('ハード参考表')
    end
    scenario 'クリア参考表のリンクが存在する' do
      expect(page).to have_link('CLEAR', sheet_path(iidxid: user.iidxid, type: 'clear'))
    end
  end

  context '楽曲更新時', js: true do
    background do
      create(:sheet, id: 1, active: true)
      login(user)
      visit sheet_path(iidxid: user.iidxid, type: 'hard')
    end

    scenario 'モーダルが降りてくる' do
      click_on 'MyString'
      expect(page).to have_content('クリア情報更新')
    end

    scenario '楽曲が更新でき，ログが作られている' do
      expect(user.scores.empty?).to eq true
      expect(user.logs.empty?).to eq true
      click_on 'MyString'
      wait_for_ajax
      select 'CLEAR', from: 'score_state'
      click_on '更新'
      wait_for_ajax
      visit sheet_path(iidxid: user.iidxid, type: 'clear')
      expect(user.scores.first.state).to eq 3
      expect(Log.exists?(user_id: 1, sheet_id: 1, pre_state: 7, new_state: 3)).to eq true
    end
  end
end
