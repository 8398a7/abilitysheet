# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

describe User::Ist, type: :model do
  describe '#update_ist' do
    let(:user) { create(:user, iidxid: '8594-9652') }
    it '同期できる' do
      VCR.use_cassette('sync_sheet') do
        RedisHelper.load_sheets_data
        sync_sheet
      end
      VCR.use_cassette('ist') do
        user.update_ist
      end
      scores = user.scores.is_current_version
      expect(scores.find_by(sheet_id: Sheet.find_by(title: '東京神話'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        state: 2,
        score: 2394,
        bp: 34
      )
      expect(user.logs.find_by(sheet_id: Sheet.find_by(title: '東京神話'))).to have_attributes(
        version: Abilitysheet::Application.config.iidx_version,
        pre_state: 7,
        new_state: 2,
        pre_score: nil,
        new_score: 2394,
        pre_bp: nil,
        new_bp: 34
      )
      expect(scores.find_by(sheet_id: Sheet.find_by(title: 'Go Beyond!!'))).to be_blank
    end
  end
end
