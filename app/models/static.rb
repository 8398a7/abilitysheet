class Static < ActiveRecord::Base
  belongs_to :sheet

  def self.irt(hash)
    hash.each do |k, v|
      power = Static.find_by(sheet_id: k)
      power.update(c: v)
    end
  end

  def self.irt_incomp
    data = nil
    open('./tmp/c', 'r') { |f| data = Marshal.load(f) }
    irt(data[1])
  end
end
