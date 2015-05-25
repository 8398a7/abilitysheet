class WelcomesController < ApplicationController
  def index
    category = %w(12-10 12-11 12-12 13-01 13-02 13-03 13-04 13-05 13-06 13-07 13-08 13-09 13-10 13-11 13-12 14-01 14-02 14-03 14-04 14-05 14-06 14-07 14-08 14-09 14-10 14-11 14-12 15-01)
    @column = LazyHighCharts::HighChart.new('column') do |f|
      f.title(text: '月別更新数')
      f.chart(type: 'column')
      f.xAxis(categories: category)
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.yAxis(allowDecimals: false, title: { text: '更新数' })
      f.series(name: 'FC', data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], color: '#ff8c00')
      f.series(name: 'EXH', data: [0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 0, 1, 1, 2, 3, 2, 1, 2, 3, 5, 0, 1, 0, 2, 20, 10, 5], color: '#ffd900')
      f.series(name: 'HARD', data: [0, 2, 0, 1, 9, 5, 18, 9, 5, 6, 2, 10, 2, 3, 5, 15, 8, 1, 3, 2, 4, 1, 0, 2, 7, 12, 5, 3], color: '#ff6347')
      f.series(name: 'CLEAR', data: [0, 4, 1, 6, 9, 11, 3, 8, 8, 3, 3, 5, 1, 0, 2, 1, 1, 0, 2, 0, 1, 0, 0, 3, 0, 0, 0, 1], color: '#afeeee')
      f.series(name: 'EASY', data: [2, 7, 6, 7, 9, 12, 4, 8, 8, 2, 1, 1, 1, 0, 3, 4, 5, 0, 3, 3, 1, 1, 0, 2, 0, 2, 0, 0], color: '#98fb98')
    end
    @spline  = LazyHighCharts::HighChart.new('spline') do |f|
      f.title(text: '未達成推移')
      f.chart(type: 'spline')
      f.xAxis(categories: category)
      f.yAxis(allowDecimals: false, max: 169, title: { text: '未達成数' })
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.series(name: '未クリア', data: [167, 159, 152, 143, 126, 108, 98, 84, 76, 73, 71, 70, 69, 69, 64, 58, 51, 50, 44, 37, 33, 31, 30, 26, 25, 14, 10, 8], color: '#afeeee')
      f.series(name: '未難', data: [169, 167, 167, 166, 157, 152, 134, 125, 120, 114, 112, 102, 100, 97, 92, 76, 68, 66, 63, 59, 55, 54, 53, 51, 44, 31, 26, 23], color: '#ff6347')
      f.series(name: '未EXH', data: [169, 169, 169, 169, 169, 169, 169, 168, 168, 166, 166, 166, 165, 164, 162, 159, 157, 156, 154, 151, 146, 146, 145, 145, 143, 123, 113, 108], color: '#ffd900')
      f.series(name: '未FC', data: [169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169], color: '#ff8c00')
    end
  end

  def list
    @cnt = User.count
    user_ids = Score.order(updated_at: :desc).pluck(:user_id).uniq
    user_ids.slice!(200, user_ids.count - 1)
    @users = User.where(id: user_ids)
    @color = Score.list_color
  end

  def message
    @message = Message.new
  end

  def create_message
    message = Message.new
    message.user_id = current_user.id if user_signed_in?
    message.email = params[:message][:email]
    message.body = params[:message][:body]
    message.ip = request.remote_ip
    result = message.save
    NoticeMail.new_message(message.id).deliver if result
    flash[:notice] = '承りました。対応はしばしお待ちください。' if result
    flash[:alert] = '何らかの不具合で送信できていません。Twitterなどにご連絡下さい。' unless result
    redirect_to root_path
  end
end
