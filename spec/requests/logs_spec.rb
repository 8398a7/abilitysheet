describe Abilitysheet::V1::Logs, type: :request do
  include_context 'api'

  describe 'GET /api/v1/logs/1111-1111/2016/3' do
    before do
      create(:sheet, id: 1, title: 'logs sample')
      create(:sheet, id: 2, title: 'logs sample2')
      create(:user, iidxid: '1111-1111', id: 1)
      create(:log, sheet_id: 2, user_id: 1, new_state: 4, created_date: '2016-02-03')
      create(:log, sheet_id: 1, user_id: 1, new_state: 3, created_date: '2016-03-01')
      create(:log, sheet_id: 2, user_id: 1, new_state: 1, created_date: '2016-03-03')
    end
    let(:url) { '/api/v1/logs/1111-1111/2016/3' }
    let(:method) { 'get' }
    let(:result) do
      [
        {
          state: 3,
          title: 'logs sample',
          created_date: '2016-03-01'
        },
        {
          state: 1,
          title: 'logs sample2',
          created_date: '2016-03-03'
        }
      ]
    end
    it_behaves_like '200 Success'
  end
end
