class UnauthorizedError < RuntimeError; end
class Forbidden < RuntimeError; end
class BadRequest < RuntimeError; end
class ServiceUnavailable < RuntimeError; end
class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }

  rescue_from ServiceUnavailable, with: :render_503
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Forbidden, with: :render_403
  rescue_from UnauthorizedError, with: :render_401
  rescue_from BadRequest, JSON::ParserError, TypeError, ArgumentError, with: :render_400

  def authenticate!
    raise UnauthorizedError unless current_user
  end

  def authenticate_member!
    raise UnauthorizedError unless current_user
    raise UnauthorizedError if current_user.role < User::Role::MEMBER
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
end
