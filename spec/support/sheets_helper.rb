# frozen_string_literal: true

module SheetsHelper
  def sync_sheet
    redis = Redis.new
    ret = JSON.parse(redis.get('sheets'))
    Sheet.insert_all!(ret['sheets'])
  end
end
