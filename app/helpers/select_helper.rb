# frozen_string_literal: true

module SelectHelper
  def check_boxes_prefs
    User::Static::PREF.map do |pref|
      User.new(pref: User::Static::PREF.index(pref))
    end
  end

  def check_boxes_n_abilities
    Static::POWER.map do |_, index|
      Sheet.new(n_ability: index)
    end
  end

  def check_boxes_h_abilities
    Static::POWER.map do |_, index|
      Sheet.new(h_ability: index)
    end
  end

  def check_boxes_exh_abilities
    Static::EXH_POWER.map do |_, index|
      Sheet.new(exh_ability: index)
    end
  end
end
