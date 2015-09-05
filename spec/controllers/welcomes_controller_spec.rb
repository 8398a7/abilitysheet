describe WelcomesController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the page as @column' do
      expect(assigns(:column)).to eq Graph::TOP_COLUMN
    end
    it 'assigns the page as @spline' do
      expect(assigns(:spline)).to eq Graph::TOP_SPLINE
    end
  end
end
