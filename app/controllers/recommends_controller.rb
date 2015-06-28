class RecommendsController < ApplicationController
  before_action :load_color
  before_action :load_sheets

  def list
  end

  def integration
  end

  private

  def load_sheets
    @sheets = Sheet.active.preload(:ability)
  end

  def load_color
    @color = Static::COLOR
  end
end
