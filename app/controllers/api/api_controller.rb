# frozen_string_literal: true

class UnauthorizedError < RuntimeError; end

class Forbidden < RuntimeError; end

class BadRequest < RuntimeError; end

class ServiceUnavailable < RuntimeError; end

class Api::ApiController < ActionController::API
  rescue_from ServiceUnavailable, with: :render_503
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Forbidden, with: :render_403
  rescue_from UnauthorizedError, with: :render_401
  rescue_from BadRequest, JSON::ParserError, TypeError, ArgumentError, with: :render_400
  after_action :add_response_header_user_id

  def authenticate!
    raise UnauthorizedError unless current_user
  end

  def authenticate_admin!
    raise UnauthorizedError unless current_user
    raise UnauthorizedError unless current_user.admin?
  end

  def authenticate_slack!
    return if params[:token] == ENV['MANAGEMENT_SLACK_TOKEN']

    raise Forbidden
  end

  private

  def render_503
    handle_error(503, 'Service Unavailable')
  end

  def render_404
    handle_error(404, 'Not Found')
  end

  def render_403
    handle_error(403, 'Forbidden')
  end

  def render_401
    handle_error(401, 'Unauthorized')
  end

  def render_400
    handle_error(400, 'Bad Request')
  end

  def handle_error(status, message)
    render json: { error: message }, status: status
  end

  def add_response_header_user_id
    response.set_header('X-User-Id', current_user&.iidxid.to_s)
  end
end
