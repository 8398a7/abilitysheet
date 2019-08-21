# frozen_string_literal: true

require 'twitter_dispatcher'

module Irt
  class Sync
    def self.run
      hash = fetch
      Ability.sync(hash)
      twitter = TwitterDispatcher.new
      twitter.tweet('地力値表を更新しました')
    end

    def self.fetch
      # token  = ENV['IRT_TOKEN']
      uri    = URI.parse(ENV['RECOMMEND_SERVER'])
      res    = Net::HTTP.get(uri)
      JSON.parse(res)['result']
    end
  end
end
