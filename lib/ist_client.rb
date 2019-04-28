# frozen_string_literal: true

class IstClient
  def initialize(url = 'https://score.iidx12.tk')
    @url = url
  end

  def get_scores(iidxid, params)
    endpoint = @url + "/api/v1/scores/#{iidxid}?" + params.to_query
    body = HTTP.get(endpoint).body
    JSON.parse(body.to_s)
  end

  def get_sheets(params)
    endpoint = @url + '/api/v1/sheets?' + params.to_query
    body = HTTP.get(endpoint).body
    JSON.parse(body.to_s)
  end

  def get_user(iidxid)
    endpoint = @url + "/api/v1/users/#{iidxid}"
    body = HTTP.get(endpoint).body
    hash = JSON.parse(body.to_s)
    hash['image_path'] = @url + hash['image_path']
    hash
  end
end
