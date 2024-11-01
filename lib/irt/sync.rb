# frozen_string_literal: true

module Irt
  class Sync
    def self.run
      hash = fetch
      Ability.sync(hash)
    end

    def self.fetch
      # token  = ENV['IRT_TOKEN']
      uri    = URI.parse(ENV['RECOMMEND_SERVER'])
      res    = Net::HTTP.get(uri)
      JSON.parse(res)['result']
    end
  end
end
