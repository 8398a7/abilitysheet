class LogsController < ApplicationController
  before_filter :authenticate_user!

  def sheet
    @sheets = Sheet.order(:title)
    @color = Score.list_color
  end

  def list
    @logs = User.find_by(iidxid: params[:iidxid]).logs.pluck(:created_at).uniq
  end

  def show
    @logs = Log.where(user_id: current_user.id, created_at: params[:date]).preload(:sheet)
    @color = Score.list_color
  end

  def graph
    user_id = User.find_by(iidxid: params[:iidxid]).id
    unless Log.exists?(user_id: user_id)
      flash[:alert] = '更新データがありません！'
      redirect_to list_logs_path and return
    end
    oldest = (User.find_by(id: user_id).logs.order(created_at: :desc).last.created_at.strftime('%Y-%m') + '-01').to_date
    now = Time.now.strftime('%Y-%m')
    lastest = (now + '-01').to_date
    between = between_create(oldest, lastest)

    category, fc_count, exh_count, h_count, c_count, e_count, cl_cnt, hd_cnt = [], [], [], [], [], [], [], []
    st = between.first[0]
    all = Sheet.all.count
    between.each do |b|
      category.push(b[0].strftime('%Y-%m').slice(2, 5))
      cl_cnt.push(all - Log.where(user_id: user_id, new_state: 0..4, created_at: st..b[1]).select(:sheet_id).uniq.count)
      hd_cnt.push(all - Log.where(user_id: user_id, new_state: 0..2, created_at: st..b[1]).select(:sheet_id).uniq.count)
      fc_count.push(Log.where(user_id: user_id, new_state: 0, created_at: b[0]..b[1]).count)
      exh_count.push(Log.where(user_id: user_id, new_state: 1, created_at: b[0]..b[1]).count)
      h_count.push(Log.where(user_id: user_id, new_state: 2, created_at: b[0]..b[1]).count)
      c_count.push(Log.where(user_id: user_id, new_state: 3, created_at: b[0]..b[1]).count)
      e_count.push(Log.where(user_id: user_id, new_state: 4, created_at: b[0]..b[1]).count)
    end

    @column = LazyHighCharts::HighChart.new('column') do |f|
      f.title(text: '月別更新数')
      f.chart(type: 'column')
      f.xAxis(categories: category)
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.yAxis(allowDecimals: false, title: { text: '更新数' })
      f.series(name: 'FC', data: fc_count, color: '#ff8c00')
      f.series(name: 'EXH', data: exh_count, color: '#fffacd')
      f.series(name: 'HARD', data: h_count, color: '#ff6347')
      f.series(name: 'CLEAR', data: c_count, color: '#afeeee')
      f.series(name: 'EASY', data: e_count, color: '#98fb98')
    end

    @spline = LazyHighCharts::HighChart.new('spline') do |f|
      f.title(text: '未クリア，未難推移')
      f.chart(type: 'spline')
      f.xAxis(categories: category)
      f.yAxis(allowDecimals: false, max: all, title: { text: '未達成数' })
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.series(name: '未クリア', data: cl_cnt, color: '#afeeee')
      f.series(name: '未難', data: hd_cnt, color: '#ff6347')
    end
  end

  private

  def between_create(o, l)
    array = []
    s = o
    while 0 < 1
      e = s + 1.months - 1.days
      array.push([s, e])
      s += 1.months
      break if s == l + 1.months
    end
    array
  end
end
