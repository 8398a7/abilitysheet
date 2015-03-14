class LogsController < ApplicationController
  before_action :scrape_maneger, only: [:maneger]

  def sheet
    @sheets = Sheet.active.order(:title)
    @color = Score.list_color
    @id = User.find_by(iidxid: params[:iidxid]).id
  end

  def list
    @logs = User.find_by(iidxid: params[:iidxid]).logs.pluck(:created_at).uniq
  end

  def maneger
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    flash[:alert] = %(反映されていない場合はマネージャに該当IIDXIDが存在しないと思われます。(登録しているけどIIDXIDを設定していないなど))
    redirect_to list_logs_path
  end

  def iidxme
    IidxmeWorker.perform_async(current_user.id)
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    flash[:alert] = %(反映されていない場合はIIDXMEに該当IIDXIDが存在しないと思われます。(登録していないなど))
    render :reload
  end

  def show
    user_id = User.find_by(iidxid: params[:iidxid]).id
    @logs = Log.where(user_id: user_id, created_at: params[:date]).preload(:sheet)
    list = User.find_by(iidxid: params[:iidxid]).logs.pluck(:created_at).uniq
    @prev_update, @next_update = prev_next(user_id, params[:date])
    @color = Score.list_color
  end

  def graph
    user_id = User.find_by(iidxid: params[:iidxid]).id
    unless Log.exists?(user_id: user_id)
      flash[:alert] = '更新データがありません！'
      redirect_to list_logs_path and return
    end
    @column = Log.column(user_id)
    @spline = Log.spline(user_id)
  end

  private

  def scrape_maneger
    @result = ManegerWorker.perform_async(current_user.id)
  end

  def prev_next(user_id, created_at)
    logs = User.find_by(id: user_id).logs.order(:created_at).pluck(:created_at).uniq
    prev_u, next_u = nil, nil
    (0..logs.count - 1).each do |cnt|
      if logs[cnt].strftime == created_at
        prev_u = logs[cnt - 1] if 0 <= cnt - 1
        next_u = logs[cnt + 1] if cnt + 1 <= logs.count - 1
      end
    end
    return prev_u, next_u
  end
end
