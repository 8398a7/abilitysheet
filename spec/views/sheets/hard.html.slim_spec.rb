require 'rails_helper'

RSpec.describe 'sheets/hard.html.slim', type: :request do
  let(:user) { create(:user, id: 1) }
  before { visit sheet_path(iidxid: user.iidxid, type: 'hard') }

  context 'ログイン時' do
    before { login_as(user, scope: :user, run_callbacks: false) }
    it 'ハード参考表の文字が存在する' do
      expect(page).to have_content('ハード参考表')
    end
    it 'クリア参考表のリンクが存在する' do
      expect(page).to have_link('CLEAR', sheet_path(iidxid: user.iidxid, type: 'clear'))
    end
  end

  context '非ログイン時' do
    it 'ハード参考表の文字が存在する' do
      expect(page).to have_content('ハード参考表')
    end
    it 'クリア参考表のリンクが存在する' do
      expect(page).to have_link('CLEAR', sheet_path(iidxid: user.iidxid, type: 'clear'))
    end
  end

  context '楽曲更新時', js: true do
    before do
      create(:sheet, id: 1, active: true)
      create(:score, id: 1, user_id: 1, sheet_id: 1, state: 6)
      login_as(user, scope: :user, run_callbacks: false)
      visit sheet_path(iidxid: user.iidxid, type: 'hard')
    end

    it 'モーダルが降りてくる' do
      click_on 'MyString'
      expect(page).to have_content('クリア情報更新')
    end

    it '楽曲が更新でき，ログが作られている' do
      wait_for_ajax
      expect(Score.find_by(id: 1).state).to eq 6
      expect(Log.exists?(user_id: 1, sheet_id: 1, pre_state: 6, new_state: 3)).to eq false
      click_on 'MyString'
      sleep(1)
      select 'CLEAR', from: 'score_state'
      click_on '更新'
      visit sheet_path(iidxid: user.iidxid, type: 'clear')
      expect(Score.find_by(id: 1).state).to eq 3
      expect(Log.exists?(user_id: 1, sheet_id: 1, pre_state: 6, new_state: 3)).to eq true
    end
  end
end
