# frozen_string_literal: true

class IstClient
  class NotFoundUser < StandardError; end

  def initialize(url = 'https://score.iidx.app')
    @url = url
  end

  def get_scores(iidxid, params)
    endpoint = @url + "/api/v1/scores/#{iidxid}?" + params.to_query
    body = HTTP.get(endpoint).body
    JSON.parse(body.to_s)
  end

  def get_musics(params)
    endpoint = @url + '/api/v1/musics?' + params.to_query
    body = HTTP.get(endpoint).body
    JSON.parse(body.to_s)
  end

  def get_user(iidxid)
    endpoint = @url + "/api/v1/users/#{iidxid}"
    resp = HTTP.get(endpoint)
    raise NotFoundUser if resp.status == 404

    hash = JSON.parse(resp.body.to_s)
    return hash unless hash.dig('image_path')

    hash['image_path'] = @url + hash['image_path']
    hash
  end
end
