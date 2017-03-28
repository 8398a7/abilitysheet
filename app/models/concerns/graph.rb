# frozen_string_literal: true

module Graph
  extend ActiveSupport::Concern

  included do
    def self.column(start_month, end_month)
      between = create_between(start_month, end_month)
      category = []
      fc_count = []
      exh_count = []
      h_count = []
      c_count = []
      e_count = []
      between.each do |b|
        category.push(b[0].strftime('%Y-%m'))
        fc_count.push(lamp_where_count(0, b[0]..b[1]))
        exh_count.push(lamp_where_count(1, b[0]..b[1]))
        h_count.push(lamp_where_count(2, b[0]..b[1]))
        c_count.push(lamp_where_count(3, b[0]..b[1]))
        e_count.push(lamp_where_count(4, b[0]..b[1]))
      end
      [fc_count, exh_count, h_count, c_count, e_count]
    end

    def self.spline(start_month, end_month)
      between = create_between(start_month, end_month)
      st = order(:created_date).first.try(:created_date)
      return [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]] unless st
      all_sheet = Sheet.active
      fc_cnt = []
      exh_cnt = []
      h_cnt = []
      c_cnt = []
      between.each do |b|
        all = all_sheet.where('created_at < ?', b[1]).count
        c_cnt.push(all - lamp_where_count(0..4, st..b[1]))
        h_cnt.push(all - lamp_where_count(0..2, st..b[1]))
        exh_cnt.push(all - lamp_where_count(0..1, st..b[1]))
        fc_cnt.push(all - lamp_where_count(0, st..b[1]))
      end
      [fc_cnt, exh_cnt, h_cnt, c_cnt]
    end

    def self.lamp_where_count(state, between)
      count = 0
      sheet_ids = []
      where(new_state: state, created_date: between).each do |instance|
        next if sheet_ids.include?(instance.sheet_id)
        next if instance.new_state == instance.pre_state
        sheet_ids.push(instance.sheet_id)
        count += 1
      end
      count
    end

    def self.create_between(received_start, received_end)
      range = []
      new_start = received_start
      loop do
        new_end = new_start + 1.month - 1.days
        range.push([new_start, new_end])
        new_start += 1.month
        break if new_start == received_end + 1.month
      end
      range
    end
  end
end
