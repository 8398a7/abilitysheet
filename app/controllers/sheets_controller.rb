class SheetsController < ApplicationController
  before_action :set_sheet

  def clear
    @sheets = Sheet.order(:ability, :title)
  end

  def hard
    @sheets = Sheet.order(:h_ability, :title)
  end

  private

  def set_sheet
    @power = Sheet.power
    s = User.find_by(iidxid: params[:iidxid]).scores
    @color = Score.convert_color(s)
  end
end
