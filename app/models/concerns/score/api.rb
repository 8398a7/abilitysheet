module Score::API
  extend ActiveSupport::Concern

  included do
    def self.pie
      (0..7).each.map { |state| where(state: state).count }
    end
  end
end
