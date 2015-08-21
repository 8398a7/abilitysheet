require 'rails_helper'

RSpec.describe Abilitysheet::V1::Users, type: :request do
  include_context 'api'

  describe 'GET /api/v1/users' do
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
