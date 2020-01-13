# frozen_string_literal: true

class IstClient
  class NotFoundUser < StandardError; end

  def initialize(url = 'https://score.iidx.app')
    @url = url
  end

  def get_scores(iidxid, params)
    endpoint = @url + "/api/v1/scores/#{iidxid}?" + params.to_query
    body = Net::HTTP.get(URI.parse(endpoint))
    JSON.parse(body)
  end

  def get_musics(params)
    endpoint = @url + '/api/v1/musics?' + params.to_query
    body = Net::HTTP.get(URI.parse(endpoint))
    JSON.parse(body)
  end

  def get_user(iidxid)
    endpoint = @url + "/api/v1/users/#{iidxid}"
    resp = Net::HTTP.get_response(URI.parse(endpoint))
    raise NotFoundUser if resp.code == '404'

    hash = JSON.parse(resp.body)
    return hash unless hash.dig('image_path')

    hash['image_path'] = @url + hash['image_path']
    hash
  end
end
