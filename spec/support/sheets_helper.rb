module SheetsHelper
  def sync_sheet
    redis = Redis.new
    sheets = JSON.parse(redis.get('sheets'))
    sheets.each { |sheet| Sheet.create(sheet) }
  end
end
