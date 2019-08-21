# frozen_string_literal: true

module Score::Api
  extend ActiveSupport::Concern

  included do
    def schema
      {
        sheet_id: sheet_id,
        title: title,
        state: state,
        score: score,
        bp: bp,
        version: version,
        updated_at: updated_at
      }
    end

    def self.pie
      ret = Array.new(8, 0)
      all.each do |score|
        ret[score.state] += 1
      end
      ret[7] += Sheet.active.count - ret.sum
      ret
    end
  end
end
