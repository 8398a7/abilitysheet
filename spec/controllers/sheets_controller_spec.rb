# frozen_string_literal: true

describe SheetsController, type: :controller do
  before do
    @user = create(:user)
  end

  describe 'GET #show -> power' do
    it 'response ok' do
      get :show, params: { iidxid: @user.iidxid, type: 'power' }
      expect(response).to be_successful
    end
  end

  describe 'GET #show -> #clear' do
    it 'response ok' do
      get :show, params: { iidxid: @user.iidxid, type: 'clear' }
      expect(response).to be_successful
    end
  end

  describe 'GET #show -> #hard' do
    it 'response ok' do
      get :show, params: { iidxid: @user.iidxid, type: 'hard' }
      expect(response).to be_successful
    end
  end
end
