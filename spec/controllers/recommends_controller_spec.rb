# frozen_string_literal: true
describe RecommendsController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the page as @color' do
      expect(assigns(:color)).to eq Static::COLOR
    end
    it 'assigns the page as @sheets' do
      expect(assigns(:sheets)).to eq Sheet.active.preload(:ability)
    end
  end
end
