require 'rails_helper'

RSpec.describe 'sheets/power.html.slim', type: :view do
  let(:user) { create(:user, id: 1) }
  before { visit sheet_path(iidxid: user.iidxid, type: 'power') }

  context 'ログイン時' do
    before { login_as(user, scope: :user, run_callbacks: false) }
    it 'iidx.meの文字が存在する' do
      expect(page).to have_content('iidx.me')
    end
  end

  context '非ログイン時' do
    it 'iidx.meの文字が存在する' do
      expect(page).to have_content('iidx.me')
    end
  end
end
