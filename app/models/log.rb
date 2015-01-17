class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :sheet
  delegate :title,   to: :sheet

  def self.data_create(id, sheet_id, state, sc = -2, bp = -2)
    sheet_id = sheet_id
    scores = User.find_by(id: id).scores
    pre_state = 7
    pre_state = scores.find_by(sheet_id: sheet_id).state if scores.exists?(sheet_id: sheet_id)
    return if pre_state == state
    create(
      user_id: id, sheet_id: sheet_id,
      pre_state: pre_state, new_state: state,
      pre_score: nil, new_score: nil,
      pre_bp: nil, new_bp: nil,
      version: AbilitysheetIidx::Application.config.iidx_version
    )
  end
end
