# frozen_string_literal: true

class SheetDecorator < Draper::Decorator
  delegate_all

  def normal
    Static::POWER[object.n_ability].first
  end

  def hard
    Static::POWER[object.h_ability].first
  end
end
