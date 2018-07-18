# frozen_string_literal: true

describe Admin::UsersController, type: :controller do
  let(:user) { create(:user, role: User::Role::ADMIN, id: 2) }
  describe 'GET #index' do
    context '非ログイン' do
      before { get :index }
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人以外' do
      before do
        user.update!(role: user.role - 1)
        sign_in user
        get :index
      end
      it 'response redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
    context '管理人' do
      before do
        sign_in user
        get :index
      end
      it 'response ok' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #new' do
    before do
      sign_in user
      get :new, xhr: true
    end
    it 'response ok' do
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    before { sign_in user }
    it 'creates a new User' do
      expect do
        post :create, xhr: true, params: {
          user: {
            email: 'hoge@iidx.tk',
            iidxid: '3472-4938',
            djname: 'BAR',
            password: 'hogehoge',
            username: 'admin_test',
            pref: 0,
            grade: Abilitysheet::Application.config.iidx_grade
          }
        }
      end.to change(User, :count).by(1)
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    before { sign_in user }
    context 'xhrリクエスト' do
      it 'response ok' do
        get :edit, xhr: true, params: { id: 2 }
        expect(assigns(:score)).to eq @score
        expect(response).to be_successful
      end
    end
    context '非xhrリクエスト' do
      it 'response redirect' do
        get :edit, params: { id: 2 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PUT #update' do
    before { sign_in user }
    it 'response ok' do
      patch :update, xhr: true, params: { id: 2, user: { grade: 5 } }
      expect(response).to be_successful
      expect(User.find_by(id: 2).grade).to eq 5
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
      create(:user, id: 3, iidxid: '4847-4938', username: 'delete')
    end
    it 'response ok' do
      expect(User.exists?(id: 3)).to eq true
      delete :destroy, xhr: true, params: { id: 3 }
      expect(response).to be_successful
      expect(User.exists?(id: 3)).to eq false
    end
  end

  describe 'POST #lock' do
    before do
      sign_in user
      create(:user, id: 3, iidxid: '4847-4938', username: 'delete')
    end
    it 'response ok' do
      expect(User.find_by(id: 3).access_locked?).to eq false
      post :lock, xhr: true, params: { id: 3 }
      expect(response).to be_successful
      expect(User.find_by(id: 3).access_locked?).to eq true
    end
  end

  describe 'POST #unlock' do
    before do
      sign_in user
      us = create(:user, id: 3, iidxid: '4847-4938', username: 'delete')
      us.lock_access!
    end
    it 'response ok' do
      expect(User.find_by(id: 3).access_locked?).to eq true
      post :unlock, xhr: true, params: { id: 3 }
      expect(response).to be_successful
      expect(User.find_by(id: 3).access_locked?).to eq false
    end
  end
end
