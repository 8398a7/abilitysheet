# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::BaseController
  def index
    authenticate_member!
    render json: { num: Message.where(state: false).count }
  end
end
