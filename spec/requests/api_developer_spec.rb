require 'rails_helper'

RSpec.describe V22::Developer do
  describe 'POST /api/v22/developer/sheets' do
    let(:user) { FactoryGirl.create(:user) }
    context 'admin user以外で実行した場合' do
      it 'パスワードが正しい場合でもUser Errorを返す' do
        user.update(admin: false)
        pattern = '{"result":"User Error."}'
        post '/api/v22/developer/sheets', { user: user.username, password: user.password }
        expect(response.body).to eq pattern
      end
      it 'パスワードが正しくない場合はUser Errorを返す' do
        user.update(admin: false)
        pattern = '{"result":"User Error."}'
        post '/api/v22/developer/sheets', { user: user.username, password: user.password }
        expect(response.body).to eq pattern
      end
    end

    context 'admin userで実行した場合' do
      it 'パスワードが正しい場合は空のJSONを返す' do
        pattern = '{"result":[]}'
        post '/api/v22/developer/sheets', { user: user.username, password: user.password }
        expect(response.body).to eq pattern
      end
      it 'パスワードが正しくない場合はUser Errorを返す' do
        pattern = '{"result":"User Error."}'
        post '/api/v22/developer/sheets', { user: user.username, password: 'hogefoobar' }
        expect(response.body).to eq pattern
      end
    end
  end
end
