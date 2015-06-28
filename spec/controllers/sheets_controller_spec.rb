require 'rails_helper'

RSpec.describe SheetsController, type: :controller do
  before do
    @user = create(:user)
  end

  describe 'GET #power' do
    it 'response ok' do
      get :power, iidxid: @user.iidxid
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #clear' do
    it 'response ok' do
      get :clear, iidxid: @user.iidxid
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #hard' do
    it 'response ok' do
      get :hard, iidxid: @user.iidxid
      expect(response).to have_http_status(:success)
    end
  end
end
