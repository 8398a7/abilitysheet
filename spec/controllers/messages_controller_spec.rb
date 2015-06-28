require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  include Devise::TestHelpers

  describe 'GET #new' do
    it '新しいページが正しく開ける' do
      get :new
      expect(assigns(:message)).to be_a_new(Message)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it '新しくメッセージを作る' do
      expect do
        post :create, message: { body: 'test' }
      end.to change(Message, :count).by(1)
      expect(response).to have_http_status(:redirect)
    end
  end
end
