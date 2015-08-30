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

  describe 'POST /api/v1/users/score_viewer' do
    let(:user) { create(:user) }
    let(:url) { '/api/v1/users/score_viewer' }
    let(:method) { 'post' }
    context 'ログインしている' do
      before { login_as(user, scope: :user, run_callbacks: false) }
      context 'データが正常な場合' do
        let(:parameters) do
          {
            'id' => user.iidxid,
            'state' => "[{\"id\":\"1\",\"cl\":1,\"pg\":1158,\"g\":373,\"miss\":6},{\"id\":\"2\",\"cl\":6,\"pg\":1362,\"g\":584,\"miss\":83}"
          }
        end
        describe '正常なレスポンスを返す' do
          let(:result) do
            { status: 'ok' }
          end
          it_behaves_like '201 Created'
        end
      end
      context 'データが不正な場合' do
        context 'iidxidが現在登録されているユーザと違う場合' do
          before { login_as(user, scope: :user, run_callbacks: false) }
          let(:parameters) do
            {
              'id' => '0000-0000',
              'state' => "[{\"id\":\"1\",\"cl\":1,\"pg\":1158,\"g\":373,\"miss\":6},{\"id\":\"2\",\"cl\":6,\"pg\":1362,\"g\":584,\"miss\":83}"
            }
          end
          it_behaves_like '401 Unauthorized'
        end
        context '楽曲情報が存在していない場合' do
          before { login_as(user, scope: :user, run_callbacks: false) }
          let(:parameters) do
            {
              'id' => user.iidxid
            }
          end
          it_behaves_like '400 Bad Request'
        end
      end
    end
    context 'ログインしていない' do
      let(:parameters) do
        {
          'id' => '0000-0000',
          'state' => "[{\"id\":\"1\",\"cl\":1,\"pg\":1158,\"g\":373,\"miss\":6},{\"id\":\"2\",\"cl\":6,\"pg\":1362,\"g\":584,\"miss\":83}"
        }
      end
      it_behaves_like '401 Unauthorized'
    end
  end
end
