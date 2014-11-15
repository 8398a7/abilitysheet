class LogsController < ApplicationController
  before_filter :authenticate_user!

  def sheet
    @sheets = Sheet.order(:title)
    @color = Score.list_color
  end

  def list
    @logs = Log.pluck(:created_at).uniq
  end

  def show
    @logs = Log.where(user_id: current_user.id, created_at: params[:date])
    @color = Score.list_color
  end
end
