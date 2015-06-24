require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::TestHelpers

  before do
    (1..2).each do |i|
      FactoryGirl.create(:user, iidxid: format('0000-%04d', i), username: format('test%d', i))
    end
  end
  context '#index' do
    before { get :index }
    it 'アクセスできる' do
      expect(response.code).to eq '200'
    end
    it 'プレイヤー数の取得が正しい' do
      expect(assigns(:cnt)).to eq 2
    end
  end

  context '#call_back' do
    before do
      post :call_back, id: '[1, 2, 3]'
    end
    it 'アクセスできる' do
      expect(response.code).to eq '200'
    end
    it 'jsonが返ってくる' do
      ret = '{"1":{"title":"","stateColor":"","updatedAt":""},"2":{"title":"","stateColor":"","updatedAt":""}}'
      expect(response.body).to eq ret
    end
  end
end
