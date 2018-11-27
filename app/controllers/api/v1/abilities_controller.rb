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
end
