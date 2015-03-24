class Static < ActiveRecord::Base
  belongs_to :sheet

  def self.async(data)
    data.each do |d|
      static = find_by(sheet_id: d['sheet_id'])
      static.update(fc: d['fc'], exh: d['exh'], h: d['h'], c: d['c'], e: d['e'])
    end
  end
end
