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

class Score < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
  delegate :title, to: :sheet

  include IIDXME
  include ScoreViewer

  validates :sheet_id, uniqueness: { scope: [:version, :user_id] }

  scope :is_not_noplay, -> { where.not(state: 7) }
  scope :is_active, -> { where(sheet_id: Sheet.active.pluck(:id)) }

  def update_with_logs(score_params)
    score_params.stringify_keys!
    # 何も変更がない状態は反映しない
    duplicate = check_duplicate(score_params)
    return false if duplicate

    user.logs.attributes(score_params, user)
    update(score_params)
  end

  def self.last_updated
    order(updated_at: :desc).where('state != ?', 7).first
  end

  def lamp_string
    str = %w(FC EXH H C E A F N)
    str[state]
  end

  def active?
    Sheet.find_by(id: sheet_id).active
  end

  class << self
    def score_create(iidxid)
      user_id = User.find_by(iidxid: iidxid).id
      sheets = Sheet.all
      version = Abilitysheet::Application.config.iidx_version
      sheets.each { |s| Score.create(sheet_id: s.id, user_id: user_id, version: version) }
    end

    def stat_info(scores)
      hash = { 'FC' => 0, 'EXH' => 0, 'H' => 0, 'C' => 0, 'E' => 0, 'A' => 0, 'F' => 0, 'N' => 0 }
      count = 0
      scores.each do |s|
        next unless s.active?
        hash[s.lamp_string] += 1
        count += 1
      end
      # hash['N'] += Sheet.active.count - count
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
      {
        'FULL COMBO' => 0, 'EXH CLEAR' => 1, 'HARD CLEAR' => 2, CLEAR: 3, 'EASY CLEAR' => 4,
        'ASSIST CLEAR' => 5, FAILED: 6, 'NO PLAY' => 7
      }
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
