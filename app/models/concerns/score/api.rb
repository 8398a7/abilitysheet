module Score::API
  extend ActiveSupport::Concern

  included do
    def self.pie
      pie = {}
      (0..7).each do |state|
        pie[Static::LAMP[state]] = where(state: state).count
      end
      pie
    end
  end
end
