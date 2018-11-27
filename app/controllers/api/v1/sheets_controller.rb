# frozen_string_literal: true

class Api::V1::SheetsController < Api::V1::BaseController
  def index
    render json: { sheets: Sheet.active.map(&:schema) }
  end

  def list
    render json: { sheets: Sheet.order(:id) }
  end
end
