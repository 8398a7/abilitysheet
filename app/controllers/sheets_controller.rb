class SheetsController < ApplicationController
  before_action :set_power

  def clear
    @sheets = Sheet.order(:ability, :title).all
  end

  def hard
    @sheets = Sheet.order(:h_ability, :title).all
  end

  private

  def set_power
    @power = Sheet.power
  end
end
