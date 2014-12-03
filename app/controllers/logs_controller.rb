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
    flash[:notice] = '同期処理を承りました。逐次反映を行います。'
    flash[:alert] = '反映されていない場合はマネージャに該当IIDXIDが存在しないと思われます。(登録しているけどIIDXIDを設定していないなど)'
    redirect_to list_logs_path
  end

  def show
    user_id = User.find_by(iidxid: params[:iidxid]).id
    @logs = Log.where(user_id: user_id, created_at: params[:date]).preload(:sheet)
    list = User.find_by(iidxid: params[:iidxid]).logs.pluck(:created_at).uniq
    @prev_update, @next_update = prev_next(user_id, params[:date])
    @color = Score.list_color
  end

  def title_push(user_id, state, b)
    array = []
    Log.where(user_id: user_id, new_state: state, created_at: b[0]..b[1]).each do |log|
      array.push([Sheet.find_by(id: log.sheet_id).title, 1])
    end
    array
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

    category, fc_count, exh_count, h_count, c_count, e_count = [], [], [], [], [], []
    fc_cnt, exh_cnt, hd_cnt, cl_cnt = [], [], [], []
    fc_t, exh_t, h_t, c_t, e_t = [], [], [], [], []
    st = between.first[0]
    all = Sheet.active.count
    between.each do |b|
      category.push(b[0].strftime('%Y-%m').slice(2, 5))
      cl_cnt.push(all - Log.where(user_id: user_id, new_state: 0..4, created_at: st..b[1]).select(:sheet_id).uniq.count)
      hd_cnt.push(all - Log.where(user_id: user_id, new_state: 0..2, created_at: st..b[1]).select(:sheet_id).uniq.count)
      exh_cnt.push(all - Log.where(user_id: user_id, new_state: 0..1, created_at: st..b[1]).select(:sheet_id).uniq.count)
      fc_cnt.push(all - Log.where(user_id: user_id, new_state: 0, created_at: st..b[1]).select(:sheet_id).uniq.count)
      fc_count.push(Log.where(user_id: user_id, new_state: 0, created_at: b[0]..b[1]).count)
      exh_count.push(Log.where(user_id: user_id, new_state: 1, created_at: b[0]..b[1]).count)
      h_count.push(Log.where(user_id: user_id, new_state: 2, created_at: b[0]..b[1]).count)
      c_count.push(Log.where(user_id: user_id, new_state: 3, created_at: b[0]..b[1]).count)
      e_count.push(Log.where(user_id: user_id, new_state: 4, created_at: b[0]..b[1]).count)
      fc_t += title_push(user_id, 0, b)
      exh_t += title_push(user_id, 1, b)
      h_t += title_push(user_id, 2, b)
      c_t += title_push(user_id, 3, b)
      e_t += title_push(user_id, 4, b)
    end

    @deb = h_t
    @column = LazyHighCharts::HighChart.new('column') do |f|
      f.title(text: '月別更新数')
      f.chart(type: 'column')
      f.xAxis(categories: category)
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.yAxis(allowDecimals: false, title: { text: '更新数' })
      f.series(name: 'FC', data: fc_count, color: '#ff8c00')
      f.series(name: 'EXH', data: exh_count, color: '#ffd900')
      f.series(name: 'HARD', data: h_count, color: '#ff6347')
      f.series(name: 'CLEAR', data: c_count, color: '#afeeee')
      f.series(name: 'EASY', data: e_count, color: '#98fb98')
    end

    @spline = LazyHighCharts::HighChart.new('spline') do |f|
      f.title(text: '未達成推移')
      f.chart(type: 'spline')
      f.xAxis(categories: category)
      f.yAxis(allowDecimals: false, max: all, title: { text: '未達成数' })
      f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
      f.series(name: '未クリア', data: cl_cnt, color: '#afeeee')
      f.series(name: '未難', data: hd_cnt, color: '#ff6347')
      f.series(name: '未EXH', data: exh_cnt, color: '#ffd900')
      f.series(name: '未FC', data: fc_cnt, color: '#ff8c00')
    end
  end

  private

  def scrape_maneger
    # scrape = Scrape::Maneger.new(current_user)
    # scrape.sync
    @result = ManegerWorker.perform_async(current_user.id)
  end

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

  def prev_next(user_id, created_at)
    logs = User.find_by(id: user_id).logs.order(:created_at).pluck(:created_at).uniq
    prev_u, next_u = nil, nil
    (0..logs.count-1).each do |cnt|
      if logs[cnt].strftime == created_at
        prev_u = logs[cnt-1] if 0 <= cnt-1
        next_u = logs[cnt+1] if cnt+1 <= logs.count-1
      end
    end
    return prev_u, next_u
  end
end
