# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def status
    render json: { status: current_user.try(:iidxid) }
  end

  def me
    render json: { current_user: current_user.try(:schema) }
  end
end
