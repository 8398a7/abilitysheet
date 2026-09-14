# frozen_string_literal: true

module RedisHelper
  def self.load_sheets_data
    redis = Redis.new
    sheets_path = File.expand_path('sheets.json', __dir__)
    sheets = JSON.parse(File.read(sheets_path))
    redis.set('sheets', sheets.to_json)
  end
end
