# frozen_string_literal: true

feature 'ノマゲ地力表', type: :system, js: true do
  given(:user) { create(:user, id: 1) }
  background do
    visit sheet_path(iidxid: user.iidxid, type: 'clear')
  end

  scenario '存在しないユーザへのアクセス' do
    visit sheet_path(iidxid: '1111-1111', type: 'clear')
    expect(page).to have_content('このページは存在しません')
  end

  context 'ログイン時' do
    background { login(user) }
    scenario 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD')
    end
    scenario '未クリアの表記が存在する', js: true do
      expect(page).to have_content('未クリア')
    end

    context 'モバイル', iphone6: true do
      background do
        sync_sheet
        visit sheet_path(iidxid: user.iidxid, type: 'clear')
      end
      xscenario 'PC版に切り替えたときのレイアウトが正しい' do
        expect(page).to have_content('PCサイト版')
        click_on 'PCサイト版'
        expect(page).to have_content('モバイル版')
      end
    end
  end

  context '非ログイン時' do
    scenario 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    scenario 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD')
    end
    scenario '未クリアの表記が存在する', js: true do
      expect(page).to have_content('未クリア')
    end
  end
end
