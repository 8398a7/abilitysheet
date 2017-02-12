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

describe User::Official, type: :model do
  describe '#update_official' do
    let(:user) { create(:user) }
    let(:params) { JSON.parse(File.read("#{Rails.root}/spec/mock/official.json")).deep_symbolize_keys }
    it '同期できる' do
      sync_sheet
      expect(user.update_official(params)).to eq true
      expect(Sheet.active.pluck(:id) - user.scores.pluck(:sheet_id)).to eq []
    end
  end
end
