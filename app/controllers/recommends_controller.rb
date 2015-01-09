class RecommendsController < ApplicationController
  def list
    @sheets = Sheet.active.preload(:static)
    @color = Score.list_color
  end
end
