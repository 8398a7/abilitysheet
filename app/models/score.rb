class Score < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user

  def lamp_string
    str = %w(FC EXH H C E A F N)
    str[state]
  end

  class << self
    def stat_info(scores)
      hash = { 'FC' => 0, 'EXH' => 0, 'H' => 0, 'C' => 0, 'E' => 0, 'A' => 0, 'F' => 0, 'N' => 0 }
      count = 0
      scores.each do |s|
        hash[s.lamp_string] += 1
        count += 1
      end
      hash['N'] += Sheet.count - count
      hash
    end

    def list_color
      %w(
        #ff8c00
        #fffacd
        #ff6347
        #afeeee
        #98fb98
        #9595ff
        #c0c0c0
        #ffffff
      )
    end

    def convert_color(scores)
      color = %w(
        #ff8c00
        #fffacd
        #ff6347
        #afeeee
        #98fb98
        #9595ff
        #c0c0c0
        #ffffff
      )
      hash = {}
      scores.each do |s|
        hash.store(s.sheet_id, color[s.state])
      end
      hash
    end

    def select_state
      {
        'FULL COMBO' => 0, 'EXH CLEAR' => 1, 'HARD CLEAR' => 2, CLEAR: 3, 'EASY CLEAR' => 4,
        'ASSIST CLEAR' => 5, FAILED: 6, 'NO PLAY' => 7
      }
    end

    def update(current_user, params, version)
      score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:score][:sheet_id], version: version)
      score = Score.new if score.nil?
      score.user_id = current_user.id
      score.sheet_id = params[:score][:sheet_id]
      score.state = params[:score][:state]
      score.version = version
      score.save
    end
  end
end
