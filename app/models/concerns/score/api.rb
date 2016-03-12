module Score::API
  extend ActiveSupport::Concern

  included do
    def schema
      {
        sheet_id: sheet_id,
        title: title,
        state: state,
        score: score,
        bp: bp
      }
    end

    def self.pie
      (0..7).each.map { |state| where(state: state).count }
    end
  end
end
