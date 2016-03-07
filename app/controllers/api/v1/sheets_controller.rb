class Api::V1::SheetsController < Api::V1::BaseController
  def index
    render json: { sheets: Sheet.order(:id) }
  end
end
