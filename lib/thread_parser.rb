# frozen_string_literal: true

module Levenshtein
  def self.similarity(str1, str2)
    1 - normalized_distance(str1, str2)
  end
end

class ThreadParser
  def initialize(query, type)
    @query = query
    @status = -1
    @sheets = []
    @titles = Sheet.pluck(:id, :title)
    @type = type
    @abilities = Sheet.pluck(:id, @type.to_sym).to_h
    @result = {}
  end

  def run
    parse
    specifies
    check
  end

  private

  def parse
    @query.each_line do |line|
      line.chomp!
      next if line.empty?
      next if line.include?('参考表')
      if line.include?('地力') || line.include?('個人差')
        @status += 1
        @sheets.push([])
        next
      end
      line.split(',').each do |title|
        title.gsub!('[L]', '†LEGGENDARIA')
        title.gsub!('LEGGENDARIA', '') if title.include?('Beat Radiance')
        @sheets[@status].push(title.strip)
      end
    end
  end

  def specifies
    num = -1
    @sheets.each do |titles|
      num += 1
      @result[num] = []
      titles.each do |title|
        @result[num].push(specify(title) => title)
      end
    end
    @result
  end

  def check
    ng = {}
    @result.each do |ability, sheet_ids|
      ids = []
      sheet_ids.each do |hash|
        sheet_id = hash.keys[0]
        next if @abilities[sheet_id] == ability
        ids.push(sheet_id)
      end
      Sheet.where(id: ids).each do |sheet|
        ng[sheet.title] = {
          info: JSON.parse(sheet.to_json),
          diff: {
            now: Static::POWER[@abilities[sheet.id]],
            thread: Static::POWER[ability]
          }
        }
      end
    end
    ng
  end

  def specify(title)
    best = {
      sim: -1,
      sheet_id: nil
    }

    @titles.each do |sheet_id, base_title|
      sim = Levenshtein.similarity(base_title, title)
      next unless best[:sim] < sim
      best[:sim] = sim
      best[:sheet_id] = sheet_id
    end
    best[:sheet_id]
  end
end
