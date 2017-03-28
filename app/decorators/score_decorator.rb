# frozen_string_literal: true

class ScoreDecorator < Draper::Decorator
  delegate_all

  def updated_at
    return '' unless object.updated_at
    object.updated_at.to_date.strftime
  end
end
