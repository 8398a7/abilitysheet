module RedisHelper
  def self.load_sheets_data
    redis = Redis.new
    uri = URI.parse('https://iidx12.tk/api/v1/sheets')
    sheets = JSON.parse(Net::HTTP.get(uri))
    redis.set('sheets', sheets.to_json)
  end
end
