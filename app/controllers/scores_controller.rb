class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :version_confirm
  before_action :load_score, only: [:update]

  def edit
    unless request.xhr?
      return_404
      return
    end
    unless current_user.scores.exists?(sheet_id: params[:id], version: @version)
      flash[:alert] = 'この状態が続くようであればお問い合わせください'
      render :reload
      return
    end
    @sheet = Sheet.find_by(id: params[:id])
    @score = current_user.scores.find_by(sheet_id: params[:id], version: @version)
    render :show_modal
  end

  def update
    @score.update_with_logs(score_params)
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
