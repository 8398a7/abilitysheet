class SheetDecorator < Draper::Decorator
  delegate_all

  def normal
    "#{Grade::POWER[object.n_ability].first}"
  end

  def hard
    "#{Grade::POWER[object.h_ability].first}"
  end
end
