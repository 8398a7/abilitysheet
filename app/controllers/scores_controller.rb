class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :version_confirm
  before_action :load_score, only: [:update]

  def edit
    unless request.xhr?
      return_404
      return
    end
    @sheet = Sheet.find_by(id: params[:id])
    if User.find_by(id: current_user.id).scores.exists?(sheet_id: params[:id], version: @version)
      @score = User.find_by(id: current_user.id).scores.find_by(sheet_id: params[:id], version: @version)
    else
      @score = Score.new
    end
    render :show_modal
  end

  def update
    @score.update(score_params)
    render :reload
  end

  private

  def load_score
    return unless params[:score][:sheet_id]
    @score = current_user.scores.find_by(sheet_id: params[:score][:sheet_id])
  end

  def score_params
    params.require(:score).permit(
      :sheet_id, :state
    )
  end

  def version_confirm
    @version = Abilitysheet::Application.config.iidx_version
  end
end
