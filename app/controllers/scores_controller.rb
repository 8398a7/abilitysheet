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
    Score.update(current_user, params, @version)
    render :reload
  end

  private

  def version_confirm
    @version = AbilitysheetIidx::Application.config.iidx_version
  end
end
