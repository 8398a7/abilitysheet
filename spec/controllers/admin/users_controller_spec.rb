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
        user.update(role: user.role - 1)
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
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #new' do
    before do
      sign_in user
      xhr :get, :new
    end
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before { sign_in user }
    it 'creates a new User' do
      expect do
        xhr :post, :create, user: { email: 'hoge@iidx.tk', iidxid: '3472-4938', djname: 'BAR', password: 'hogehoge', username: 'admin_test', pref: 0, grade: 0 }
      end.to change(User, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    before { sign_in user }
    context 'xhrリクエスト' do
      it 'response ok' do
        xhr :get, :edit, id: 2
        expect(assigns(:score)).to eq @score
        expect(response).to have_http_status(:success)
      end
    end
    context '非xhrリクエスト' do
      it 'response redirect' do
        get :edit, id: 2
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PUT #update' do
    before { sign_in user }
    it 'response ok' do
      xhr :patch, :update, id: 2, user: { grade: 5 }
      expect(response).to have_http_status(:success)
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
      xhr :delete, :destroy, id: 3
      expect(response).to have_http_status(:success)
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
      xhr :post, :lock, id: 3
      expect(response).to have_http_status(:success)
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
      xhr :post, :unlock, id: 3
      expect(response).to have_http_status(:success)
      expect(User.find_by(id: 3).access_locked?).to eq false
    end
  end
end
