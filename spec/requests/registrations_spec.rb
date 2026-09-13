# frozen_string_literal: true

describe Users::RegistrationsController, type: :request do
  describe 'POST /users' do
    let(:registration_attributes) do
      attributes_for(:user).merge(password_confirmation: 'hogehoge')
    end

    before do
      expect(Slack::UserDispatcher).not_to receive(:new_register_notify)
      expect(IstSyncJob).not_to receive(:perform_later)
    end

    it '有効な登録情報を直接送信しても作成せず、デラレコを案内する' do
      expect do
        post user_registration_path, user: registration_attributes
      end.not_to change(User, :count)

      expect(last_response.status).to eq(403)
      expect(last_response.body).to include('新規登録の受付は終了しました。')
      expect(Capybara.string(last_response.body)).to have_link('デラレコで新規登録', href: 'https://record.iidx.app/')
      expect(Capybara.string(last_response.body)).to have_no_selector('form[action="/users"]')
    end

    it 'JSONで登録情報を送信しても作成しない' do
      expect do
        post user_registration_path(format: :json), { user: registration_attributes }.to_json,
             'CONTENT_TYPE' => 'application/json', 'HTTP_ACCEPT' => 'application/json'
      end.not_to change(User, :count)

      expect(last_response.status).to eq(403)
    end
  end

  describe '既存ユーザのアカウント編集' do
    let(:user) { create(:user) }

    before { login(user) }

    it '編集ページを表示できる' do
      get edit_user_registration_path

      expect(last_response.status).to eq(200)
      expect(Capybara.string(last_response.body)).to have_field('user_current_password')
    end

    it '現在のパスワードでプロフィールを更新できる' do
      expect do
        patch user_registration_path, user: { djname: 'EDIT', current_password: 'hogehoge' }
      end.to change { user.reload.djname }.from('TEST').to('EDIT')

      expect(last_response.status).to eq(302)
    end
  end
end
