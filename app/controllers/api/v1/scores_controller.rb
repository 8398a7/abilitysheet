# frozen_string_literal: true

class Api::V1::ScoresController < Api::V1::BaseController
  before_action :load_user, except: :sync_official
  before_action :authenticate!, only: :update

  def show
    render json: @user.scores.is_active.is_current_version.preload(:sheet).map(&:schema)
  end

  def detail
    sheet = Sheet.find(params[:sheet_id])
    render json: {
      title: sheet.title,
      scores: @user.scores.includes(:sheet).where(sheet_id: params[:sheet_id]).order(version: :desc).map(&:schema),
      textage: sheet.textage
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
    raise ServiceUnavailable unless SidekiqDispatcher.exists?
  rescue ServiceUnavailable => ex
    Raven.user_context(@user.attributes)
    Raven.capture_exception(ex)
    SidekiqDispatcher.start!
  ensure
    IidxmeJob.perform_later(@user.id)
    render json: { result: :ok, date: Date.today }
  end

  def sync_official
    raise ServiceUnavailable unless SidekiqDispatcher.exists?
  rescue ServiceUnavailable => ex
    Raven.user_context(current_user.attributes)
    Raven.capture_exception(ex)
    SidekiqDispatcher.start!
  ensure
    if params[:scores].present?
      OfficialJob.perform_later(current_user.id, params.to_json)
    end
    head :ok
  end

  private

  def load_user
    @user = User.find_by_iidxid!(params[:iidxid])
  end
end
