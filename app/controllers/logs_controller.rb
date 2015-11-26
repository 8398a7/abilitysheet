class LogsController < ApplicationController
  before_action :scores_exists?, only: %w(manager iidxme)
  before_action :special_user!, only: %w(update_official)
  before_action :load_user, only: %w(sheet list show)

  def sheet
    @sheets = Sheet.active.order(:title)
    @color = Static::COLOR
    @id = @user.id
  end

  def list
    per_num = 10
    logs = @user.logs.order(created_date: :desc).select(:created_date).uniq
    @logs = logs.page(params[:page]).per(per_num)
    @total_pages = (logs.count / per_num.to_f).ceil
  end

  def manager
    ManagerWorker.perform_async(current_user.id)
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
    OfficialWorker.perform_async(current_user.id, params[:kid], params[:password])
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    redirect_to list_log_path
  end

  def show
    begin
      date = params[:date].to_date
    rescue
      return_404
      return
    end
    unless @user
      return_404
      return
    end
    @logs = Log.where(user_id: @user.id, created_date: date).preload(:sheet)
    unless @logs.present?
      return_404
      return
    end
    @prev_update, @next_update = Log.prev_next(@user.id, date)
    @color = Static::COLOR
  end

  def graph
    @user = User.find_by(iidxid: params[:id])
    unless @user
      return_404
      return
    end
    user_id = @user.id
    unless Log.exists?(user_id: user_id)
      flash[:alert] = '更新データがありません！'
      redirect_to list_log_path
      return
    end
    @column = Log.column(user_id)
    @spline = Log.spline(user_id)
  end

  private

  def load_user
    @user = User.find_by(iidxid: params[:id])
  end
end
