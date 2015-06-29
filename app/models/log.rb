# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sheet_id   :integer
#  pre_state  :integer
#  new_state  :integer
#  pre_score  :integer
#  new_score  :integer
#  pre_bp     :integer
#  new_bp     :integer
#  version    :integer
#  created_at :date
#

class Log < ActiveRecord::Base
  belongs_to :user
  belongs_to :sheet
  delegate :title, to: :sheet

  include Graph

  def self.attributes(score_params, _sc = -2, _bp = -2, owner)
    log = find_by(sheet_id: score_params[:sheet_id], created_at: Date.today)
    if log
      log.update(new_state: score_params[:state])
      return
    end
    pre_state = owner.scores.find_by(sheet_id: score_params[:sheet_id]).try(:state) || 7
    owner.logs.create(
      sheet_id: score_params[:sheet_id],
      pre_state: pre_state, new_state: score_params[:state],
      pre_score: nil, new_score: nil, pre_bp: nil, new_bp: nil,
      version: Abilitysheet::Application.config.iidx_version
    )
  end
end
