class ScoresController < ApplicationController
  before_filter :authenticate_user!

  def attribute
    @title = Sheet.find_by(id: params[:id]).title
    if User.find_by(id: current_user.id).scores.exists?(sheet_id: params[:id], version: 22)
      @score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:id], version: 22)
    else
      @score = Score.new
    end
    render :show_modal
  end

  def update
    score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:score][:sheet_id], version: 22)
    score = Score.new if score.nil?
    score.user_id = current_user.id
    score.sheet_id = params[:score][:sheet_id]
    score.state = params[:score][:state]
    score.save
    render :reload
  end
end
