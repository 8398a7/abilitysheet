# frozen_string_literal: true
module SheetsHelper
  def sync_sheet
    redis = Redis.new
    ret = JSON.parse(redis.get('sheets'))
    ret['sheets'].each { |sheet| Sheet.create(sheet) }
  end
end
