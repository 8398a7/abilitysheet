class Api::V1::LogsController < Api::V1::BaseController
  def full_calendar
    user = User.find_by!(iidxid: params[:iidxid])
    start_date = (params[:year].to_s + '-' + params[:month].to_s + '-01').to_date
    end_date = start_date + 1.month
    logs = user.logs.where(created_date: start_date..end_date)
    render json: logs.preload(:sheet).map(&:schema)
  end

  def cal_heatmap
    user = User.find_by!(iidxid: params[:iidxid])
    logs = user.logs.where(created_date: params[:start]..params[:stop]).map { |c| c.created_date.to_time.to_i }
    render json: logs.each_with_object(Hash.new(0)) { |tm, h| h[tm] += 1 }
  end

  def graph
    user = User.find_by_iidxid!(params[:iidxid])
    scores = user.scores.is_active.is_current_version
    render json: {
      pie: scores.pie
    }
  end
end
