# frozen_string_literal: true
describe WelcomesController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
  end
end
