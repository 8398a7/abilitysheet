describe ScoresController, type: :controller do
  before do
    @user = create(:user, id: 1)
    create(:sheet, id: 1)
  end

  describe 'GET #edit' do
    context 'ログインしていない' do
      it 'response ng' do
        xhr :get, :edit, id: 1
        expect(response).to have_http_status(401)
      end
    end
    context 'ログインしている' do
      it 'response ok' do
        sign_in @user
        xhr :get, :edit, id: 1
        expect(assigns(:score)).to eq @user.scores.first
        expect(response).to have_http_status(:success)
      end
    end
    context 'xhrリクエストではない' do
      it 'response redirect' do
        get :edit, id: 1
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'PUT #update' do
    before { create(:score, sheet_id: 1, user_id: 1) }
    context 'ログインしていない' do
      it 'response ng' do
        xhr :patch, :update, id: @user.scores.first.id, score: { sheet_id: 1, state: 5 }
        expect(response).to have_http_status(401)
      end
    end
    context 'ログインしている' do
      it 'response ok' do
        sign_in @user
        xhr :patch, :update, id: @user.scores.first.id, score: { sheet_id: 1, state: 5 }
        expect(response).to have_http_status(:success)
        expect(@user.scores.first.state).to eq 5
      end
    end
  end
end
