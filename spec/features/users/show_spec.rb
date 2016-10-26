# frozen_string_literal: true
feature 'プロフィールページ', js: true do
  given(:user) { create(:user, id: 1, djname: 'PROF', iidxid: '1111-1111', pref: 0, grade: 4, created_at: '2016-03-06') }
  context '非ログイン時' do
    background do
      create(:score, user_id: 1, sheet_id: 1)
      visit user_path(user.iidxid)
      wait_for_ajax
    end
    scenario 'DJNAMEが存在する' do
      expect(page).to have_content('PROF')
    end
    scenario 'IIDXIDが存在する' do
      expect(page).to have_content('1111-1111')
    end
    scenario 'ノマゲ参考表のリンクが存在する' do
      expect(page).to have_link('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('ハード参考表')
    end
    scenario '段位が存在する' do
      expect(page).to have_content('八段')
    end
    scenario '所属が存在する' do
      expect(page).to have_content('海外')
    end
    scenario '登録日が存在する' do
      expect(page).to have_content('Joined on 2016/3/6')
    end
    scenario '統計情報が存在する' do
      expect(page).to have_content('統計情報')
    end
    scenario '更新履歴が存在する' do
      expect(page).to have_content('更新履歴')
    end
    scenario 'ノマゲ比較が存在しない' do
      expect(page).to have_no_content('ノマゲ比較')
    end
    scenario 'ハード比較が存在しない' do
      expect(page).to have_no_content('ハード比較')
    end
    scenario 'ライバル追加/削除が存在しない' do
      expect(page).to have_no_button('ライバルから削除')
      expect(page).to have_no_button('ライバルに追加')
    end
    scenario 'ライバル/逆ライバルの数が表示されている' do
      expect(page).to have_selector('#rival-number', text: '0')
      expect(page).to have_selector('#reverse-rival-number', text: '0')
    end
  end
  context 'ログイン時' do
    background do
      user2 = create(:user, username: 'user2', id: 2, grade: 4)
      login(user2)
      visit user_path(user.iidxid)
      wait_for_ajax
    end
    scenario 'DJNAMEが存在する' do
      expect(page).to have_content('PROF')
    end
    scenario 'IIDXIDが存在する' do
      expect(page).to have_content('1111-1111')
    end
    scenario 'ノマゲ参考表のリンクが存在する' do
      expect(page).to have_link('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('ハード参考表')
    end
    scenario '段位が存在する' do
      expect(page).to have_content('八段')
    end
    scenario '所属が存在する' do
      expect(page).to have_content('海外')
    end
    scenario '登録日が存在する' do
      expect(page).to have_content('Joined on 2016/3/6')
    end
    scenario '統計情報が存在する' do
      expect(page).to have_content('統計情報')
    end
    scenario '更新履歴が存在する' do
      expect(page).to have_content('更新履歴')
    end
    scenario 'ノマゲ比較が存在する' do
      expect(page).to have_content('ノマゲ比較')
    end
    scenario 'ハード比較が存在する' do
      expect(page).to have_content('ハード比較')
    end
    scenario 'ライバル追加/削除が行える' do
      expect(page).to have_button('ライバルに追加')
      click_button 'ライバルに追加'
      wait_for_ajax
      user.reload
      expect(page).to have_selector('#reverse-rival-number', text: '1')
      expect(user.followers.count).to eq 1
      expect(page).to have_button('ライバルから削除')
      click_button 'ライバルから削除'
      wait_for_ajax
      user.reload
      expect(page).to have_selector('#reverse-rival-number', text: '0')
      expect(user.followers.count).to eq 0
      expect(page).to have_button('ライバルに追加')
    end
    scenario 'ライバル/逆ライバルの数が表示されている' do
      expect(page).to have_selector('#rival-number', text: '0')
      expect(page).to have_selector('#reverse-rival-number', text: '0')
    end
  end
end
