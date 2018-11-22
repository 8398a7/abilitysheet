# frozen_string_literal: true

class Api::V1::LogsController < Api::V1::BaseController
  before_action :load_user!

  def full_calendar
    start_date = (params[:year].to_s + '-' + params[:month].to_s + '-01').to_date
    end_date = start_date + 1.month
    logs = @user.logs.where(created_date: start_date..end_date)
    render json: { logs: logs.preload(:sheet).map(&:schema) }
  end

  def cal_heatmap
    logs = @user.logs.where(created_date: params[:start]..params[:stop]).map { |c| c.created_date.to_time.to_i }
    render json: logs.each_with_object(Hash.new(0)) { |tm, h| h[tm] += 1 }
  end

  def graph
    end_month = "#{params[:year]}-#{params[:month]}-01".to_date
    start_month = end_month - 2.months
    render json: @user.graph(start_month, end_month)
  end

  private

  def load_user!
    @user = User.find_by_iidxid!(params[:iidxid])
  end
end
