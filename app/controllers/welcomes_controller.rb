class WelcomesController < ApplicationController
  def index
    @column = Graph::TOP_COLUMN
    @spline = Graph::TOP_SPLINE
  end
end
