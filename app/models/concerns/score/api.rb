# frozen_string_literal: true

module Score::API
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
      Sheet.active.each do |sheet|
        state = find_by(sheet_id: sheet.id).try(:state)
        state ||= 7
        ret[state] += 1
      end
      ret
    end
  end
end
