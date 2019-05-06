# frozen_string_literal: true

module RedisHelper
  def self.load_sheets_data
    redis = Redis.new
    uri = URI.parse('https://sp12.iidx.app:12222/api/v1/sheets/list')
    sheets = JSON.parse(Net::HTTP.get(uri))
    redis.set('sheets', sheets.to_json)
  rescue Errno::ECONNREFUSED
    puts '本番サーバが稼働していません'
    redis.set('sheets', '{"sheets":[]}')
  end
end
