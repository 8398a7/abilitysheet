class Score < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
  delegate :title,   to: :sheet

  include IIDXME

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
      version = AbilitysheetIidx::Application.config.iidx_version
      sheets.each { |s| Score.create(sheet_id: s.id, user_id: user_id, version: version) }
    end

    def official_create(title, score, miss, state, user_id)
      sheet = Sheet.find_by(title: title)
      return unless sheet
      p title, score, state, miss, user_id
      update(user_id, sheet.id, state)
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

    def list_color
      %w(
        #ff8c00
        #ffd900
        #ff6347
        #afeeee
        #98fb98
        #9595ff
        #c0c0c0
        #ffffff
      )
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
      color = %w(
        #ff8c00
        #ffd900
        #ff6347
        #afeeee
        #98fb98
        #9595ff
        #c0c0c0
        #ffffff
      )
      hash = {}
      scores.each { |s| hash.store(s.sheet_id, color[s.state]) }
      hash
    end

    def select_state
      {
        'FULL COMBO' => 0, 'EXH CLEAR' => 1, 'HARD CLEAR' => 2, CLEAR: 3, 'EASY CLEAR' => 4,
        'ASSIST CLEAR' => 5, FAILED: 6, 'NO PLAY' => 7
      }
    end

    def update(id, sheet_id, state, sc = -2, bp = -2)
      version = AbilitysheetIidx::Application.config.iidx_version
      score = find_by(user_id: id, sheet_id: sheet_id, version: version)
      Log.data_create(id, sheet_id, state, sc, bp) if score.state != state
      score = Score.new if score.nil?
      score.user_id = id
      score.sheet_id = sheet_id
      score.state = state
      score.version = version
      score.save
    end
  end
end
