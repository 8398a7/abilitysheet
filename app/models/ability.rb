class Ability < ActiveRecord::Base
  belongs_to :sheet

  def self.async(data)
    data.each do |d|
      find_by(sheet_id: d['sheet_id']).update(fc: d['fc'], exh: d['exh'], h: d['h'], c: d['c'], e: d['e'])
    end
  end
end
