# frozen_string_literal: true

module Sheet::API
  extend ActiveSupport::Concern

  included do
    def schema
      {
        title: title,
        clear: n_ability,
        hard: h_ability,
        exh: exh_ability,
        clear_string: Static::POWER[n_ability][0],
        hard_string: Static::POWER[h_ability][0],
        exh_string: Sheet.find_exh_ability_from_integer(exh_ability)[0],
        version: version
      }
    end
  end
end
