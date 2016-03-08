# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  state      :integer          default(7), not null
#  score      :integer
#  bp         :integer
#  sheet_id   :integer          not null
#  user_id    :integer          not null
#  version    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_scores_on_sheet_id    (sheet_id)
#  index_scores_on_updated_at  (updated_at)
#  index_scores_on_user_id     (user_id)
#

class Score < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
  delegate :title, to: :sheet

  include Score::IIDXME
  include Score::ScoreViewer

  validates :sheet_id, uniqueness: { scope: [:version, :user_id] }

  scope :is_not_noplay, -> { where.not(state: 7) }
  scope :is_active, -> { where(sheet_id: Sheet.active.pluck(:id)) }
  scope :is_current_version, -> { where(version: Abilitysheet::Application.config.iidx_version) }

  def self.remain(type)
    state = type == :hard ? 2 : 4
    Sheet.active.size - where(state: 0..state).size
  end

  def self.remain_string(type)
    hash = { clear: '☆12ノマゲ参考表(未クリア', hard: '☆12ハード参考表(未難' }
    hash[type] + "#{remain(type)})"
  end

  def update_with_logs(score_params)
    score_params.stringify_keys!
    # 何も変更がない状態は反映しない
    duplicate = check_duplicate(score_params)
    return false if duplicate

    user.logs.attributes(score_params, user)
    update(score_params)
  end

  def self.last_updated
    order(updated_at: :desc).where.not(state: 7).first
  end

  def lamp_string
    Static::LAMP[state]
  end

  def active?
    sheet.active
  end

  class << self
    def stat_info(scores)
      hash = Static::LAMP.map { |e| [e, 0] }.to_h
      count = 0
      scores.each do |s|
        next unless s.active?
        hash[s.lamp_string] += 1
        count += 1
      end
      hash
    end

    def list_name
      [
        'FULL COMBO',
        'EXH CLEAR',
        'HARD CLEAR',
        'CLEAR',
        'EASY CLEAR',
        'ASSIST CLEAR',
        'FAILED',
        'NO PLAY'
      ]
    end

    def convert_color(scores)
      hash = {}
      scores.each { |s| hash.store(s.sheet_id, Static::COLOR[s.state]) }
      hash
    end

    def select_state
      list_name.map.with_index(0) { |e, i| [e, i] }.to_h
    end
  end

  private

  def check_duplicate(s)
    s.each do |k, v|
      v = v.to_i unless v.class == NilClass
      return false if k == 'state' && try(k).nil? && v.to_i == 7
      return false if try(k) != v
    end
    true
  end
end
