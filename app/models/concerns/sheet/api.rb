# frozen_string_literal: true
module Sheet::API
  extend ActiveSupport::Concern

  included do
    def schema
      {
        title: title,
        clear: n_ability,
        hard: h_ability,
        clear_string: Static::POWER[n_ability][0],
        hard_string: Static::POWER[h_ability][0],
        version: version
      }
    end
  end
end
