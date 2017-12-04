# frozen_string_literal: true

describe ClearingTransitionTableService, type: :service do
  let(:user) { create(:user) }
  let(:sheet) { create(:sheet, active: true) }

  it 'ログの状態から正しく楽曲の推移hashが作れること' do
    user.logs.create!(sheet_id: sheet.id, pre_state: 4, new_state: 3, created_date: Date.today - 1.day)
    user.logs.create!(sheet_id: sheet.id, pre_state: 3, new_state: 1, created_date: Date.today)
    expect(ClearingTransitionTableService.new(user).execute).to eq(
      sheet.title => {
        3 => Date.today - 1.day,
        1 => Date.today
      }
    )
  end
end
