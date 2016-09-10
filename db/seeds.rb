uri = URI.parse('https://iidx12.tk/api/v1/sheets/list')
sheets = JSON.parse(Net::HTTP.get(uri))
sheets['sheets'].each { |sheet| Sheet.create(sheet) }
