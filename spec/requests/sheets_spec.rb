# frozen_string_literal: true

describe Api::V1::SheetsController, type: :request do
  include_context 'api'

  describe 'GET /api/v1/sheets' do
    before { create(:sheet, id: 1, active: true) }
    let(:url) { '/api/v1/sheets' }
    let(:method) { 'get' }
    let(:result) do
      {
        1 => {
          title: 'MyString',
          clear: 1,
          hard: 1,
          exh: 1,
          clear_string: '個人差S+',
          hard_string: '個人差S+',
          exh_string: '難度11',
          version: 1
        }
      }
    end
    it_behaves_like '200 Success'
  end

  describe 'GET /api/v1/sheets/list' do
    before { @sheet = create(:sheet, id: 1) }
    let(:url) { '/api/v1/sheets/list' }
    let(:method) { 'get' }
    let(:result) do
      {
        sheets: [
          {
            id: 1,
            title: 'MyString',
            n_ability: 1,
            h_ability: 1,
            exh_ability: 1,
            version: 1,
            active: false,
            textage: 'MyString',
            created_at: JSON.parse(@sheet.to_json)['created_at'],
            updated_at: JSON.parse(@sheet.to_json)['updated_at']
          }
        ]
      }
    end
    it_behaves_like '200 Success'
  end
end
