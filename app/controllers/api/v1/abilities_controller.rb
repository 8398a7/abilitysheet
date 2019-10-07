# frozen_string_literal: true

class Api::V1::AbilitiesController < Api::V1::BaseController
  def index
    power = params[:type] == 'exh' ? Static::EXH_POWER : Static::POWER
    render json: {
      abilities: power.map do |elem|
        { key: elem[1], value: elem[0] }
      end
    }
  end

  def create
    unless params[:api_key] == ENV.fetch('SYNC_API_KEY', '')
      render json: { status: :forbidden }, status: 403
      return
    end
    params[:sheets].each do |s|
      sheet = Sheet.find_by(title: s[:title])
      next unless sheet
      sheet.ability.update!(
        fc: s[:fc] || 99.99,
        exh: s[:exh] || 99.99,
        h: s[:h] || 99.99,
        c: s[:c] || 99.99,
        e: s[:e] || 99.99,
        aaa: s[:aaa] || 99.99,
      )
    end
    render json: { status: :created }
  end
end
