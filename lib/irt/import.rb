module IRT
  class Import
    class << self
      def go(file, type)
        data = nil
        open('./irt/' + file, 'r') { |f| data = Marshal.load(f) }
        data[1].each do |k, v|
          power = Static.find_by(sheet_id: k)
          power.update(fc:   v) if type == 0
          power.update(exh:  v) if type == 1
          power.update(h:    v) if type == 2
          power.update(c:    v) if type == 3
          power.update(e:    v) if type == 4
          power.update(aaa:  v) if type == 5
        end
      end
    end
  end
end
