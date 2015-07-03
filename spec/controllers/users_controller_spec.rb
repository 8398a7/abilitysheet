require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    (1..2).each do |i|
      create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i))
    end
    create(:score, user_id: 1, state: 6, sheet_id: 1)
  end
  describe 'GET #index' do
    before { get :index }
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
    it 'プレイヤー数の取得が正しい' do
      expect(assigns(:cnt)).to eq 2
    end
  end
end
