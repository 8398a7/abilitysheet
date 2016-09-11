# frozen_string_literal: true
module SheetsHelper
  def sync_sheet
    redis = Redis.new
    ret = JSON.parse(redis.get('sheets'))
    sheets = ret['sheets'].map { |s| Sheet.new(s) }
    Sheet.import(sheets)
  end
end
