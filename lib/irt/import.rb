module IRT
  class Import
    def self.go(file, type)
      data = nil
      open('./irt/' + file, 'r') { |f| data = Marshal.load(f) }
      data[1].each { |k, v| update_power(k, v, type) }
    end

    def self.update_power(k, v, type)
      pattern = [
        { fc: v },
        { exh: v },
        { h: v },
        { c: v },
        { e: v },
        { aaa: v }
      ]
      power = Ability.find_by(sheet_id: k)
      power.update(pattern[type])
    end
  end
end
