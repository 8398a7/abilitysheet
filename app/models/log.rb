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

  def self.prev_next(user_id, date)
    p = where(user_id: user_id).order(created_at: :desc).find_by('created_at < ?', date).try(:created_at)
    n = where(user_id: user_id).order(:created_at).find_by('created_at > ?', date).try(:created_at)
    [p, n]
  end

  def self.attributes(score_params, owner)
    score_attributes(score_params, owner) if score_params['score'] && score_params['bp']
    log = find_by(sheet_id: score_params['sheet_id'], created_at: Date.today)
    if log
      log.update(new_state: score_params['state'])
      return true
    end
    pre_state = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:state) || 7
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
      return true
    end
    now_score = owner.scores.find_by(sheet_id: score_params['sheet_id'])
    pre_state = now_score.try(:state) || 7
    owner.logs.create(
      sheet_id: score_params['sheet_id'],
      pre_state: pre_state, new_state: score_params['state'],
      pre_score: now_score.score, new_score: score_params['score'], pre_bp: now_score.bp, new_bp: score_params['bp'],
      version: Abilitysheet::Application.config.iidx_version
    )
  end
end
