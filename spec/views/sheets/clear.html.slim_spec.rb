require 'rails_helper'

RSpec.describe 'sheets/clear.html.slim', type: :request do
  let(:user) { create(:user, id: 1) }
  before { visit sheet_path(iidxid: user.iidxid, type: 'clear') }

  it '存在しないユーザへのアクセス' do
    visit sheet_path(iidxid: '1111-1111', type: 'clear')
    expect(page).to have_content('このページは存在しません')
  end

  context 'ログイン時' do
    before { login_as(user, scope: :user, run_callbacks: false) }
    it 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    it 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD', sheet_path(iidxid: user.iidxid, type: 'hard'))
    end
  end

  context '非ログイン時' do
    it 'ノマゲ参考表の文字が存在する' do
      expect(page).to have_content('ノマゲ参考表')
    end
    it 'ハード参考表のリンクが存在する' do
      expect(page).to have_link('HARD', sheet_path(iidxid: user.iidxid, type: 'hard'))
    end
  end
end
