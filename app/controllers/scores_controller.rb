class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :check_xhr
  before_action :load_score
  before_action :score_exists?, only: %w(edit)

  def edit
    @sheet = Sheet.find_by(id: params[:id])
    render :show_modal
  end

  def update
    @score.update_with_logs(score_params)
    render :reload
  end

  private

  def score_exists?
    return if @score
    flash[:alert] = '処理を受け付けませんでした．'
    flash[:notice] = 'この状態が続くようであればお問い合わせください'
    render :reload
  end

  def load_score
    version = Abilitysheet::Application.config.iidx_version
    parameters = { version: version }
    if params[:action] == 'edit'
      parameters[:sheet_id] = params[:id]
    else
      parameters[:id] = params[:id]
    end
    @score = current_user.scores.find_by(parameters)
  end

  def score_params
    params.require(:score).permit(
      :sheet_id, :state
    )
  end
end
