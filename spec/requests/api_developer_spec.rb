require 'rails_helper'

RSpec.describe V22::Developer, type: :request do
  include_context 'api'
  context 'POST /api/v22/developer/sheets' do
    before { FactoryGirl.create(:sheet, id: 1) }
    let(:url) { '/api/v22/developer/sheets' }
    let(:method) { 'post' }
    context 'admin user以外' do
      let(:user) { FactoryGirl.create(:user, admin: false) }
      describe 'パスワードが正しい' do
        let(:parameters) do
          { user: user.username, password: user.password }
        end
        it_behaves_like '403 Forbidden'
      end
      describe 'パスワードが誤り' do
        let(:parameters) do
          { user: user.username, password: 'hogefoobar' }
        end
        it_behaves_like '401 Unauthorized'
      end
    end

    context 'admin user' do
      let(:user) { FactoryGirl.create(:user) }
      describe 'パスワードが正しい場合はsheet一覧を返す' do
        let(:parameters) do
          { user: user.username, password: user.password }
        end
        let(:result) do
          {
            'result' => [
              {
                'id' => 1,
                'title' => 'MyString',
                'n_ability' => 1,
                'h_ability' => 1,
                'version' => 1,
                'active' => false,
                'textage' => 'MyString'
              }
            ]
          }
        end
        it_behaves_like '201 Created'
      end
      describe 'パスワードが誤り' do
        let(:parameters) do
          { user: user.username, password: 'hogefoobar' }
        end
        it_behaves_like '401 Unauthorized'
      end
    end
  end
  context 'POST /api/v22/developer/users' do
    before { FactoryGirl.create(:user) }
    let(:url) { '/api/v22/developer/users' }
    let(:method) { 'post' }
    describe 'ユーザの人数を返す' do
      let(:result) do
        { users: 1 }
      end
      it_behaves_like '201 Created'
    end
  end
end
