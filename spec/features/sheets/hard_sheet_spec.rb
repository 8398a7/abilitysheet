# frozen_string_literal: true

feature 'ハード地力表', js: true do
  given(:user) { create(:user, id: 1) }
  background do
    visit sheet_path(iidxid: user.iidxid, type: 'hard')
  end

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
    scenario '未難の表記が存在する', js: true do
      expect(page).to have_content('未難')
    end
  end

  context '非ログイン時' do
    scenario 'ハード参考表の文字が存在する' do
      expect(page).to have_content('ハード参考表')
    end
    scenario 'クリア参考表のリンクが存在する' do
      expect(page).to have_link('CLEAR', sheet_path(iidxid: user.iidxid, type: 'clear'))
    end
    scenario '未難の表記が存在する', js: true do
      expect(page).to have_content('未難')
    end
  end

  context '楽曲更新時' do
    background do
      create(:sheet, id: 1, active: true, textage: 'hoge')
      login(user)
      visit sheet_path(iidxid: user.iidxid, type: 'hard')
      wait_for_ajax
    end

    scenario 'モーダルが降りてくる' do
      click_on 'MyString'
      wait_for_ajax
      expect(page).to have_content('MyString')
      expect(page).to have_content('state')
      expect(page).to have_content('bp')
      expect(page).to have_content('score')
      expect(page).to have_content('version')
      expect(page).to have_content('updated at')
      expect(page).to have_content('textage(1P)')
      expect(page).to have_content('textage(2P)')
    end

    scenario '楽曲が更新でき，ログが作られている' do
      expect(user.scores.empty?).to eq true
      expect(user.logs.empty?).to eq true
      click_on 'MyString'
      wait_for_ajax
      select 'C', from: 'select_1'
      wait_for_ajax
      expect(user.scores.first.state).to eq 3
      expect(Log.exists?(user_id: 1, sheet_id: 1, pre_state: 7, new_state: 3)).to eq true
    end
  end
end
