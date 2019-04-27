# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate!, only: %i[score_viewer]

  def status
    render json: { status: current_user.try(:iidxid) }
  end

  def me
    render json: { current_user: current_user.try(:schema) }
  end

  def score_viewer
    raise Forbidden if current_user.iidxid != params[:id]

    elems = JSON.parse(params[:state])
    elems.each do |e|
      # パラメータが不足している
      raise BadRequest if !e['id'] || !e['cl'] || !e['pg'] || !e['g'] || !e['miss']
      # パラメータに余分な物がある
      raise BadRequest if e.size > 5

      # 楽曲が存在していない
      Sheet.find(e['id'])
    end
    raise ServiceUnavailable unless SidekiqDispatcher.exists?

    ScoreViewerJob.perform_later(elems, current_user.id)
    render json: { status: 'ok' }, status: 202
  rescue ServiceUnavailable => e
    Raven.user_context(current_user.attributes)
    Raven.capture_exception(e)
    SidekiqDispatcher.start!
    render json: { status: 'ok' }, status: 202
  end
end
