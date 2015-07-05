require 'rails_helper'

RSpec.describe Abilitysheet::V1::Users, type: :request do
  include_context 'api'

  describe 'GET /api/v1/users' do
    before { create(:user) }
    let(:url) { '/api/v1/users' }
    let(:method) { 'get' }
    describe 'ユーザの人数を返す' do
      let(:result) do
        { users: 1 }
      end
      it_behaves_like '200 Success'
    end
  end
end
