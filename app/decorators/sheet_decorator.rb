# frozen_string_literal: true

class SheetDecorator < Draper::Decorator
  delegate_all

  def normal
    Static::POWER[object.n_ability].first
  end

  def hard
    Static::POWER[object.h_ability].first
  end

  def exh
    Static::EXH_POWER[object.exh_ability].first
  end

  def updated_at
    return '' unless object.updated_at

    object.updated_at.strftime('%Y/%m/%d %H:%M')
  end
end
