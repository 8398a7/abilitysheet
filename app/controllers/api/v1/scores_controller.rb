class Api::V1::ScoresController < Api::V1::BaseController
  before_action :load_user
  before_action :authenticate!, only: :update

  def show
    render json: @user.scores.is_active.is_current_version.preload(:sheet).map(&:schema)
  end

  def detail
    render json: {
      title: Sheet.find(params[:sheet_id]).title,
      scores: @user.scores.where(sheet_id: params[:sheet_id]).order(version: :desc).map(&:schema)
    }
  end

  def update
    sheet = Sheet.find(params[:sheet_id])
    score = @user.scores.is_current_version.find_by_sheet_id(sheet.id)
    score ||= @user.scores.create(sheet_id: sheet.id, version: Abilitysheet::Application.config.iidx_version)
    score.update_with_logs(sheet_id: sheet.id, state: params[:state])
    render json: score.schema
  end

  def sync_iidxme
    IidxmeWorker.perform_async(@user.id)
    render json: { result: :ok, date: Date.today }
  end

  private

  def load_user
    @user = User.find_by_iidxid!(params[:iidxid])
  end
end
