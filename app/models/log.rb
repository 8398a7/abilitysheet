# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  sheet_id     :integer
#  pre_state    :integer
#  new_state    :integer
#  pre_score    :integer
#  new_score    :integer
#  pre_bp       :integer
#  new_bp       :integer
#  version      :integer
#  created_date :date
#

class Log < ApplicationRecord
  belongs_to :user
  belongs_to :sheet
  delegate :title, to: :sheet

  validates :sheet_id, uniqueness: { scope: %i[created_date user_id] }

  after_destroy :rollback_score

  include Graph

  def self.prev_next(user_id, date)
    p = where(user_id: user_id).order(created_date: :desc).find_by('created_date < ?', date).try(:created_date)
    n = where(user_id: user_id).order(:created_date).find_by('created_date > ?', date).try(:created_date)
    [p, n]
  end

  def self.attributes(score_params, owner)
    score_attributes(score_params, owner) if score_params['score'] && score_params['bp']
    log = find_by(sheet_id: score_params['sheet_id'], created_date: Date.today)
    if log
      log.update!(new_state: score_params['state'])
      return true
    end
    pre_state = owner.scores.find_by(sheet_id: score_params['sheet_id']).try(:state) || 7
    # スコアBPの更新がなく，状態が変わっていない場合はログを作らない
    return false if pre_state == score_params['state'].to_i
    owner.logs.create!(
      sheet_id: score_params['sheet_id'],
      pre_state: pre_state, new_state: score_params['state'],
      pre_score: nil, new_score: nil, pre_bp: nil, new_bp: nil,
      version: Abilitysheet::Application.config.iidx_version,
      created_date: Date.today
    )
  end

  def self.score_attributes(score_params, owner)
    log = find_by(sheet_id: score_params['sheet_id'], created_date: Date.today)
    if log
      log.update!(new_score: score_params['score'], new_bp: score_params['bp'])
      return true
    end
    now_score = owner.scores.is_current_version.find_by(sheet_id: score_params['sheet_id'])
    pre_state = now_score.try(:state) || 7
    owner.logs.create!(
      sheet_id: score_params['sheet_id'],
      pre_state: pre_state, new_state: score_params['state'],
      pre_score: now_score.score, new_score: score_params['score'], pre_bp: now_score.bp, new_bp: score_params['bp'],
      version: Abilitysheet::Application.config.iidx_version,
      created_date: Date.today
    )
  end

  # Usage: User.first.logs.cleanup!(23)
  def self.cleanup!(version)
    logs = where(version: version)
    Sheet.all.each do |sheet|
      logs.where(sheet_id: sheet.id).order(:created_date).each_cons(2) do |p_log, n_log|
        n_log.update!(pre_score: p_log.new_score, pre_bp: p_log.new_bp)
      end
    end
  end

  def schema
    {
      state: new_state,
      title: title,
      created_date: created_date
    }
  end

  private

  def rollback_score
    score = Score.find_by(user_id: user_id, sheet_id: sheet_id, version: Abilitysheet::Application.config.iidx_version)
    score.update_column(:state, pre_state)
  end
end
