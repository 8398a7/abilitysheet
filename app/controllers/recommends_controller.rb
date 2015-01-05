class RecommendsController < ApplicationController
  before_action :authenticate_user!
  def list
    @sheets = Sheet.active.preload(:static)
    @color = Score.list_color
  end
end
