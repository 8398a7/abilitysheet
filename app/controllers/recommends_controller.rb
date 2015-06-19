class RecommendsController < ApplicationController
  def list
    @sheets = Sheet.active.preload(:ability)
    @color = Static::COLOR
  end

  def integration
    @sheets = Sheet.active.preload(:ability)
    @color = Static::COLOR
  end
end
