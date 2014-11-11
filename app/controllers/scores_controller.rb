class ScoresController < ApplicationController
  def attribute
    if User.find_by(id: current_user.id).scores.exists?(sheet_id: params[:id], version: 22)
      @score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:id], version: 22)
      edit
    else
      new
      @score = Score.new
    end
    render :show_modal
  end

  private

  def new
  end

  def edit
  end
end
