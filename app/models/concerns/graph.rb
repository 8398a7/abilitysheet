module Graph
  extend ActiveSupport::Concern

  category = %w(12-10 12-11 12-12 13-01 13-02 13-03 13-04 13-05 13-06 13-07 13-08 13-09 13-10 13-11 13-12 14-01 14-02 14-03 14-04 14-05 14-06 14-07 14-08 14-09 14-10 14-11 14-12 15-01)

  TOP_COLUMN = LazyHighCharts::HighChart.new('column') do |f|
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

  TOP_SPLINE = LazyHighCharts::HighChart.new('spline') do |f|
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

  included do
    def self.column(user_id)
      between = common(user_id)
      return false unless between
      category = []
      fc_count = []
      exh_count = []
      h_count = []
      c_count = []
      e_count = []
      between.each do |b|
        category.push(b[0].strftime('%Y-%m').slice(2, 5))
        fc_count.push(lamp_where_count(user_id, 0, b[0]..b[1]))
        exh_count.push(lamp_where_count(user_id, 1, b[0]..b[1]))
        h_count.push(lamp_where_count(user_id, 2, b[0]..b[1]))
        c_count.push(lamp_where_count(user_id, 3, b[0]..b[1]))
        e_count.push(lamp_where_count(user_id, 4, b[0]..b[1]))
      end
      g = LazyHighCharts::HighChart.new('column') do |f|
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
      g
    end

    def self.spline(user_id)
      between = common(user_id)
      return false unless between
      st = between.first[0]
      all_sheet = Sheet.active
      category = []
      fc_cnt = []
      exh_cnt = []
      hd_cnt = []
      cl_cnt = []
      fc_t = []
      exh_t = []
      h_t = []
      c_t = []
      e_t = []
      between.each do |b|
        all = all_sheet.where('created_at < ?', b[1]).count
        category.push(b[0].strftime('%Y-%m').slice(2, 5))
        cl_cnt.push(all - lamp_where_count(user_id, 0..4, st..b[1]))
        hd_cnt.push(all - lamp_where_count(user_id, 0..2, st..b[1]))
        exh_cnt.push(all - lamp_where_count(user_id, 0..1, st..b[1]))
        fc_cnt.push(all - lamp_where_count(user_id, 0, st..b[1]))
        fc_t += title_push(user_id, 0, b)
        exh_t += title_push(user_id, 1, b)
        h_t += title_push(user_id, 2, b)
        c_t += title_push(user_id, 3, b)
        e_t += title_push(user_id, 4, b)
      end
      g = LazyHighCharts::HighChart.new('spline') do |f|
        f.title(text: '未達成推移')
        f.chart(type: 'spline')
        f.xAxis(categories: category)
        f.yAxis(allowDecimals: false, max: all_sheet.count, title: { text: '未達成数' })
        f.legend(layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0)
        f.series(name: '未クリア', data: cl_cnt, color: '#afeeee')
        f.series(name: '未難', data: hd_cnt, color: '#ff6347')
        f.series(name: '未EXH', data: exh_cnt, color: '#ffd900')
        f.series(name: '未FC', data: fc_cnt, color: '#ff8c00')
      end
      g
    end

    private

    def self.lamp_where_count(user_id, state, between)
      count = 0
      sheet_ids = []
      where(user_id: user_id, new_state: state, created_at: between).each do |instance|
        next if sheet_ids.include?(instance.sheet_id)
        next if instance.new_state == instance.pre_state
        sheet_ids.push(instance.sheet_id)
        count += 1
      end
      count
    end

    def self.between_create(o, l)
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

    def self.title_push(user_id, state, b)
      array = []
      Log.where(user_id: user_id, new_state: state, created_at: b[0]..b[1]).each { |log| array.push([Sheet.find_by(id: log.sheet_id).title, 1]) }
      array
    end

    def self.common(user_id)
      user = User.find_by(id: user_id)
      return false if user.nil? || user.logs.nil? || user.logs.empty?
      oldest = (user.logs.order(created_at: :desc).last.created_at.strftime('%Y-%m') + '-01').to_date
      now = Time.now.strftime('%Y-%m')
      lastest = (now + '-01').to_date
      between_create(oldest, lastest)
    end
  end
end
