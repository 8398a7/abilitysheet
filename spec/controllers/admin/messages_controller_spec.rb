# frozen_string_literal: true
describe Admin::MessagesController, type: :controller do
  before { create(:message, id: 1) }
  describe 'GET #index' do
    context '非ログイン' do
      before { get :index }
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人以外' do
      let(:user) { create(:user, role: User::Role::ADMIN - 1) }
      before do
        sign_in user
        get :index
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人' do
      let(:user) { create(:user, role: User::Role::ADMIN) }
      before do
        sign_in user
        get :index
      end
      it 'response ok' do
        expect(response).to have_http_status(:success)
      end
    end
  end
  describe 'POST #active' do
    context '非ログイン' do
      before { post :active, params: { id: 1 } }
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人以外' do
      let(:user) { create(:user, role: User::Role::ADMIN - 1) }
      before do
        sign_in user
        get :active, params: { id: 1 }
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人' do
      let(:user) { create(:user, role: User::Role::ADMIN) }
      before do
        Message.find_by(id: 1).update!(state: false)
        sign_in user
        get :active, params: { id: 1 }
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
      it 'stateが変わっている' do
        expect(Message.find_by(id: 1).state).to eq true
      end
    end
  end
  describe 'POST #inactive' do
    context '非ログイン' do
      before { post :inactive, params: { id: 1 } }
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人以外' do
      let(:user) { create(:user, role: User::Role::ADMIN - 1) }
      before do
        sign_in user
        get :inactive, params: { id: 1 }
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人' do
      let(:user) { create(:user, role: User::Role::ADMIN) }
      before do
        Message.find_by(id: 1).update!(state: true)
        sign_in user
        get :inactive, params: { id: 1 }
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
      it 'stateが変わっている' do
        expect(Message.find_by(id: 1).state).to eq false
      end
    end
  end
end
