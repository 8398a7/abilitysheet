describe Abilitysheet::V1::Sheets, type: :request do
  include_context 'api'

  # describe 'GET /api/v1/sheets' do
  #   before { create(:sheet, id: 1) }
  #   let(:url) { '/api/v1/sheets' }
  #   let(:method) { 'get' }

  #   context '非ログイン' do
  #     it_behaves_like '401 Unauthorized'
  #   end

  #   context 'ログイン' do
  #     context 'admin user以外' do
  #       let(:user) { create(:user, admin: false) }
  #       before { login(user) }
  #       it_behaves_like '403 Forbidden'
  #     end

  #     context 'admin user' do
  #       let(:user) { create(:user) }
  #       before { login(user) }
  #       describe 'パスワードが正しい場合はsheet一覧を返す' do
  #         let(:result) do
  #           {
  #             'sheets' => [
  #               {
  #                 'id' => 1,
  #                 'title' => 'MyString',
  #                 'n_ability' => 1,
  #                 'h_ability' => 1,
  #                 'version' => 1,
  #                 'active' => false,
  #                 'textage' => 'MyString'
  #               }
  #             ]
  #           }
  #         end
  #         it_behaves_like '200 Success'
  #       end
  #     end
  #   end
  # end
end
