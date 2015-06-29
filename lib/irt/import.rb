module IRT
  class Import
    def self.go(file, type)
      data = nil
      open('./irt/' + file, 'r') { |f| data = Marshal.load(f) }
      data[1].each { |k, v| update_power(k, v, type) }
    end

    def self.update_power(k, v, type)
      power = Ability.find_by(sheet_id: k)
      power.update(fc:   v) if type == 0
      power.update(exh:  v) if type == 1
      power.update(h:    v) if type == 2
      power.update(c:    v) if type == 3
      power.update(e:    v) if type == 4
      power.update(aaa:  v) if type == 5
    end
  end
end
