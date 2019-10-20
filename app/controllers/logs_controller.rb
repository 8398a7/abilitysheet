# frozen_string_literal: true

require 'ist_client'

class LogsController < ApplicationController
  before_action :load_user, only: %w[sheet list show]

  def edit
    @log = current_user.logs.find(params[:id])
    render :show_modal
  end

  def update
    log = current_user.logs.find(params[:id])
    log.update(log_params) if params['log']['created_date'].to_date
    render :reload
  end

  def sheet
    @color = Static::COLOR
    @title = 'クリア推移表'
    @sheets = ClearingTransitionTableService.new(@user).execute
  end

  def list
    per_num = 10
    logs = @user.logs.order(created_date: :desc).select(:created_date).distinct
    @logs = logs.page(params[:page]).per(per_num)
    @total_pages = (logs.count / per_num.to_f).ceil
  end

  def ist
    current_user.check_ist_user

    IstSyncJob.perform_later(current_user)
    flash[:notice] = %(同期処理を承りました。逐次反映を行います。)
    flash[:danger] = %(反映されていない場合はISTに該当IIDXIDが存在しないと思われます。(登録しているけど一度もIST側でスコアを送っていないなど))
    render :reload
  rescue IstClient::NotFoundUser
    flash[:danger] = %(IST側でユーザが見つけられませんでした。現在のバージョンでスコアを送信しているか確認してください。)
    render :reload
  end

  def show
    date = params[:date].to_date
    @logs = Log.where(user_id: @user.id, created_date: date).preload(:sheet)
    unless @logs.present?
      render_404
      return
    end
    @prev_update, @next_update = Log.prev_next(@user.id, date)
    @color = Static::COLOR
  end

  def destroy
    log = current_user.owner? ? Log.find(params[:id]) : current_user.logs.find(params[:id])
    if log
      flash[:notice] = "#{log.title}のログを削除し，状態を戻しました"
      log.destroy
    else
      flash[:notice] = '存在しないログデータです'
    end
    if log && current_user.logs.where(created_date: log.created_date).count.zero?
      redirect_to list_log_path(current_user.iidxid)
    else
      render :reload
    end
  end

  private

  def load_user
    @user = User.find_by_iidxid!(params[:id])
  end

  def log_params
    params.require(:log).permit(:created_date)
  end
end
