class LogsController < ApplicationController
  def sheet
    @sheets = Sheet.active.order(:title)
    @color = Static::COLOR
    @id = User.find_by(iidxid: params[:iidxid]).id
  end

  def list
    @logs = User.find_by(iidxid: params[:iidxid]).logs
  end

  def maneger
    ManegerWorker.perform_async(current_user.id)
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    flash[:alert] = %(反映されていない場合はマネージャに該当IIDXIDが存在しないと思われます。(登録しているけどIIDXIDを設定していないなど))
    render :reload
  end

  def iidxme
    IidxmeWorker.perform_async(current_user.id)
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    flash[:alert] = %(反映されていない場合はIIDXMEに該当IIDXIDが存在しないと思われます。(登録していないなど))
    render :reload
  end

  def official
    render :show_modal
  end

  def update_official
    unless current_user.special?
      flash[:alert] = %(不正な操作です。)
      redirect_to list_logs_path
      return
    end
    OfficialWorker.perform_async(current_user.id, params[:kid], params[:password])
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    redirect_to list_logs_path
  end

  def show
    begin
      date = params[:date].to_date
    rescue
      return_404
      return
    end
    user_id = User.find_by(iidxid: params[:iidxid]).id
    @logs = Log.where(user_id: user_id, created_at: date).preload(:sheet)
    unless @logs.present?
      return_404
      return
    end
    list = User.find_by(iidxid: params[:iidxid]).logs.pluck(:created_at).uniq
    @prev_update, @next_update = prev_next(user_id, date)
    @color = Static::COLOR
  end

  def graph
    user = User.find_by(iidxid: params[:iidxid])
    unless user
      return_404
      return
    end
    user_id = user.id
    unless Log.exists?(user_id: user_id)
      flash[:alert] = '更新データがありません！'
      redirect_to list_logs_path
      return
    end
    @column = Log.column(user_id)
    @spline = Log.spline(user_id)
  end

  private

  def prev_next(user_id, created_at)
    logs = User.find_by(id: user_id).logs.order(:created_at).pluck(:created_at).uniq
    prev_u, next_u = nil, nil
    (0..logs.count - 1).each do |cnt|
      if logs[cnt].strftime == created_at
        prev_u = logs[cnt - 1] if 0 <= cnt - 1
        next_u = logs[cnt + 1] if cnt + 1 <= logs.count - 1
      end
    end
    [prev_u, next_u]
  end
end
