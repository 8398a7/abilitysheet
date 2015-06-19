class RecommendsController < ApplicationController
  def list
    @sheets = Sheet.active.preload(:static)
    @color = Grade::COLOR
  end

  def integration
    @sheets = Sheet.active.preload(:static)
    @color = Grade::COLOR
  end
end
