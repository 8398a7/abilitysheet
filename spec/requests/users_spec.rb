# frozen_string_literal: true

describe Api::V1::UsersController, type: :request do
  include_context 'api'

  describe 'GET /api/v1/users/me' do
    before { create(:user) }
    describe 'ユーザのログイン状態を返す' do
      let(:url) { '/api/v1/users/me' }
      let(:method) { 'get' }
      context 'ログインしていない場合' do
        let(:result) do
          { current_user: nil }
        end
        it_behaves_like '200 Success'
      end

      context 'ログインしている場合' do
        before { login(User.first) }
        let(:result) do
          {
            current_user: {
              id: Integer,
              iidxid: String,
              djname: String,
              follows: Array,
              grade: Integer,
              pref: Integer,
              created_at: String,
              followers: Array,
              image_url: nil
            }
          }
        end
        it_behaves_like '200 Success'
      end
    end
  end

  describe 'GET /api/v1/users/status' do
    before { create(:user) }
    describe 'ユーザのログイン状態を返す' do
      let(:url) { '/api/v1/users/status' }
      let(:method) { 'get' }
      context 'ログインしていない場合' do
        let(:result) do
          { status: nil }
        end
        it_behaves_like '200 Success'
      end

      context 'ログインしている場合' do
        before { login(User.first) }
        let(:result) do
          { status: User.first.iidxid }
        end
        it_behaves_like '200 Success'
      end
    end
  end
end
