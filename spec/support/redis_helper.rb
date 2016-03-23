module RedisHelper
  def self.load_sheets_data
    redis = Redis.new
    uri = URI.parse('https://iidx12.tk/api/v1/sheets/list')
    sheets = JSON.parse(Net::HTTP.get(uri))
    redis.set('sheets', sheets.to_json)
  rescue
    puts '本番サーバが稼働していません'
    redis.set('sheets', '{"sheets":[]}')
  end
end
