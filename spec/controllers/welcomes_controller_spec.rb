# frozen_string_literal: true

describe WelcomesController, type: :controller do
  describe 'GET #index' do
    before { get :index }
    it 'response ok' do
      expect(response).to be_successful
    end
  end
end
