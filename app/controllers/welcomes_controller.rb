class WelcomesController < ApplicationController
  def index
    @column = Static::TOP_COLUMN
    @spline = Static::TOP_SPLINE
  end
end
