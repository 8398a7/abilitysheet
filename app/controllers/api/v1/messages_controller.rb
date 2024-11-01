# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::BaseController
  def index
    authenticate_admin!
    render json: { num: Message.where(state: false).count }
  end
end
