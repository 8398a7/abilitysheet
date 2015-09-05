RSpec.describe MessagesController, type: :controller do
  describe 'GET #new' do
    before { get :new }
    it 'response ok' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns a new page as @message' do
      expect(assigns(:message)).to be_a_new(Message)
    end
  end

  describe 'POST #create' do
    it 'creates a new Message' do
      expect do
        post :create, message: { body: 'test' }
      end.to change(Message, :count).by(1)
      expect(response).to have_http_status(:redirect)
    end
  end
end
