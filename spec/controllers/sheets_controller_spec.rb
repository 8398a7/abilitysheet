require 'rails_helper'

RSpec.describe SheetsController, type: :request do
  let(:user) { FactoryGirl.create(:user) }
  describe 'ハード参考表ページ' do
    context 'ログイン時' do
      before do
        login_as(user, scope: :user, run_callbacks: false)
        visit hard_sheets_path(user.iidxid)
      end
      it 'ハード参考表の文字が存在する' do
        expect(page).to have_content('ハード参考表')
      end
      it 'クリア参考表のリンクが存在する' do
        expect(page).to have_link('CLEAR', clear_sheets_path(user.iidxid))
      end
    end
    context '非ログイン時' do
      before { visit hard_sheets_path(user.iidxid) }
      it 'ハード参考表の文字が存在する' do
        expect(page).to have_content('ハード参考表')
      end
      it 'クリア参考表のリンクが存在する' do
        expect(page).to have_link('CLEAR', clear_sheets_path(user.iidxid))
      end
    end
  end

  describe 'ノマゲ参考表ページ' do
    context 'ログイン時' do
      before do
        login_as(user, scope: :user, run_callbacks: false)
        visit clear_sheets_path(user.iidxid)
      end
      it 'ノマゲ参考表の文字が存在する' do
        expect(page).to have_content('ノマゲ参考表')
      end
      it 'ハード参考表のリンクが存在する' do
        expect(page).to have_link('HARD', hard_sheets_path(user.iidxid))
      end
    end
    context '非ログイン時' do
      before { visit clear_sheets_path(user.iidxid) }
      it 'ノマゲ参考表の文字が存在する' do
        expect(page).to have_content('ノマゲ参考表')
      end
      it 'ハード参考表のリンクが存在する' do
        expect(page).to have_link('HARD', hard_sheets_path(user.iidxid))
      end
    end
  end

  describe '地力値参考表ページ' do
    context 'ログイン時' do
      before do
        login_as(user, scope: :user, run_callbacks: false)
        visit power_sheets_path(user.iidxid)
      end
      it 'iidx.meの文字が存在する' do
        save_and_open_page
        expect(page).to have_content('iidx.me')
      end
    end
    context '非ログイン時' do
      before { visit power_sheets_path(user.iidxid) }
      it 'iidx.meの文字が存在する' do
        expect(page).to have_content('iidx.me')
      end
    end
  end
end
