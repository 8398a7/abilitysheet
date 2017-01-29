# frozen_string_literal: true
class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate!, only: %i(change_rival score_viewer)

  def status
    render json: { status: current_user.try(:iidxid) }
  end

  def me
    render json: { current_user: current_user.try(:schema) }
  end

  def change_rival
    target_user = User.find_by!(iidxid: params[:iidxid])

    current_user.change_follow(target_user)
    render json: { current_user: current_user.try(:schema), target_user: target_user.try(:schema) }
  end

  def score_viewer
    raise Forbidden if current_user.iidxid != params[:id]
    elems = JSON.parse(params[:state])
    elems.each do |e|
      # パラメータが不足している
      raise BadRequest if !e['id'] || !e['cl'] || !e['pg'] || !e['g'] || !e['miss']
      # パラメータに余分な物がある
      raise BadRequest if 5 < e.size
      # 楽曲が存在していない
      Sheet.find(e['id'])
    end
    raise ServiceUnavailable unless SidekiqDispatcher.exists?
  rescue ServiceUnavailable => ex
    Raven.user_context(current_user.attributes)
    Raven.capture_exception(ex)
    SidekiqDispatcher.start!
  ensure
    ScoreViewerWorker.perform_async(elems, current_user.id)
    render json: { status: 'ok' }, status: 202
  end
end
