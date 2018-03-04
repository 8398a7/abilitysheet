# frozen_string_literal: true

class IstClient
  def initialize(url = 'https://score.iidx12.tk')
    @url = url
  end

  def get_sheets(params)
    endpoint = @url + '/api/v1/sheets?' + params.to_query
    body = HTTP.get(endpoint).body
    JSON.parse(body.to_s)
  end
end
