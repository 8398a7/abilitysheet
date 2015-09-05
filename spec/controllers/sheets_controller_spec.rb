RSpec.describe SheetsController, type: :controller do
  before do
    @user = create(:user)
  end

  describe 'GET #show -> power' do
    it 'response ok' do
      get :show, iidxid: @user.iidxid, type: 'power'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show -> #clear' do
    it 'response ok' do
      get :show, iidxid: @user.iidxid, type: 'clear'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show -> #hard' do
    it 'response ok' do
      get :show, iidxid: @user.iidxid, type: 'hard'
      expect(response).to have_http_status(:success)
    end
  end
end
