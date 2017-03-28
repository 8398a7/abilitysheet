# frozen_string_literal: true

class Api::V1::SheetsController < Api::V1::BaseController
  def index
    sheets = {}
    Sheet.active.each do |sheet|
      sheets[sheet.id] = sheet.schema
    end
    render json: sheets
  end

  def list
    render json: { sheets: Sheet.order(:id) }
  end
end
