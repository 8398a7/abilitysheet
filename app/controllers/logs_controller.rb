class LogsController < ApplicationController
  before_action :special_user!, only: %w(update_official)
  before_action :load_user, only: %w(sheet list show)

  def edit
    @log = current_user.logs.find_by(id: params[:id])
    render :show_modal
  end

  def update
    log = current_user.logs.find_by(id: params[:id])
    begin
      log.update(log_params) if params['log']['created_date'].to_date
    rescue
    end
    render :reload
  end

  def sheet
    @sheets = Sheet.active.order(:title)
    @color = Static::COLOR
    @id = @user.id
    @title = 'クリア推移表'
  end

  def list
    per_num = 10
    logs = @user.logs.order(created_date: :desc).select(:created_date).uniq
    @logs = logs.page(params[:page]).per(per_num)
    @total_pages = (logs.count / per_num.to_f).ceil
  end

  def manager
    if SidekiqDispatcher.exists?
      ManagerWorker.perform_async(current_user.id)
      flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
      flash[:alert] = %(反映されていない場合はマネージャに該当IIDXIDが存在しないと思われます。(登録しているけどIIDXIDを設定していないなど))
    else
      sidekiq_notify
    end
    render :reload
  end

  def iidxme
    if SidekiqDispatcher.exists?
      IidxmeWorker.perform_async(current_user.id)
      flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
      flash[:alert] = %(反映されていない場合はIIDXMEに該当IIDXIDが存在しないと思われます。(登録していないなど))
    else
      sidekiq_notify
    end
    render :reload
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

  def destroy
    log = current_user.owner? ? Log.find_by(id: params[:id]) : current_user.logs.find_by(id: params[:id])
    if log
      score = Score.find_by(user_id: log.user_id, sheet_id: log.sheet_id, version: Abilitysheet::Application.config.iidx_version)
      score.update_column(:state, log.pre_state)
      flash[:notice] = "#{log.title}のログを削除し，状態を戻しました"
      log.destroy
    else
      flash[:notice] = '存在しないログデータです'
    end
    render :reload
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

  def sidekiq_notify
    flash[:alert] = '不具合により更新できませんでした。しばらくこの症状が続く場合はお手数ですがご一報下さい'
    Slack::SidekiqDispatcher.notify
  end

  def load_user
    @user = User.find_by(iidxid: params[:id])
  end

  def log_params
    params.require(:log).permit(:created_date)
  end
end
