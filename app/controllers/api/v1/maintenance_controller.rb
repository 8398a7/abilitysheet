# frozen_string_literal: true

class Api::V1::MaintenanceController < Api::V1::BaseController
  before_action :authenticate_slack!

  def change
    mode = params[:text].split('メンテナンス ')[1]
    mode == '開始' ? system('touch /var/tmp/abilitysheet_maintenance.txt') : system('rm /var/tmp/abilitysheet_maintenance.txt')
    head :ok
  end
end
