require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user, id: 1)
    FactoryGirl.create(:sheet, id: 1)
    @score = FactoryGirl.create(:score, id: 1, user_id: 1, sheet_id: 1, state: 7)
  end

  describe 'GET #edit' do
    context 'ログインしていない' do
      it 'アクセスできない' do
        xhr :get, :edit, id: 1
        expect(response).to have_http_status(401)
      end
    end
    context 'ログインしている' do
      it 'アクセスできる' do
        sign_in @user
        xhr :get, :edit, id: 1
        expect(assigns(:score)).to eq @score
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'ログインしていない' do
      it '更新できない' do
        xhr :patch, :update, id: 1, score: { sheet_id: 1, state: 5 }
        expect(response).to have_http_status(401)
      end
    end
    context 'ログインしている' do
      it '更新できる' do
        sign_in @user
        xhr :patch, :update, id: 1, score: { sheet_id: 1, state: 5 }
        expect(response).to have_http_status(:success)
        expect(Score.find_by(id: 1).state).to eq 5
      end
    end
  end
end
