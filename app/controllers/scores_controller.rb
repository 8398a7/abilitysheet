class ScoresController < ApplicationController
  before_filter :authenticate_user!
  before_action :version_confirm

  def attribute
    @title = Sheet.find_by(id: params[:id]).title
    if User.find_by(id: current_user.id).scores.exists?(sheet_id: params[:id], version: @version)
      @score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:id], version: @version)
    else
      @score = Score.new
    end
    render :show_modal
  end

  def update
    score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:score][:sheet_id], version: @version)
    score = Score.new if score.nil?
    score.user_id = current_user.id
    score.sheet_id = params[:score][:sheet_id]
    score.state = params[:score][:state]
    score.version = @version
    score.save
    render :reload
  end

  private

  def version_confirm
    @version = AbilitysheetIidx::Application.config.iidx_version
  end
end
