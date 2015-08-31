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

  def self.attributes(score_params, owner)
    score_attributes(score_params, owner) if score_params['score'] && score_params['bp']
    log = find_by(sheet_id: score_params['sheet_id'], created_at: Date.today)
    if log
      log.update(new_state: score_params['state'])
      return
    end
    pre_state = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:state) || 7
    return if pre_state == score_params['state'].to_i
    owner.logs.create(
      sheet_id: score_params['sheet_id'],
      pre_state: pre_state, new_state: score_params['state'],
      pre_score: nil, new_score: nil, pre_bp: nil, new_bp: nil,
      version: Abilitysheet::Application.config.iidx_version
    )
  end

  def self.score_attributes(score_params, owner)
    log = find_by(sheet_id: score_params['sheet_id'], created_at: Date.today)
    if log
      log.update(new_score: score_params['score'], new_bp: score_params['bp'])
      return
    end
    pre_state = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:state) || 7
    pre_score = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:score) || -1
    pre_bp = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:bp) || 9999
    return if score_params['score'] < pre_score && pre_bp < score_params['bp']
    pre_bp = nil if pre_bp == 9999
    pre_score = nil if pre_score == -1
    owner.logs.create(
      sheet_id: score_params['sheet_id'],
      pre_state: pre_state, new_state: score_params['state'],
      pre_score: pre_score, new_score: score_params['score'], pre_bp: pre_bp, new_bp: score_params['bp'],
      version: Abilitysheet::Application.config.iidx_version
    )
  end
end
