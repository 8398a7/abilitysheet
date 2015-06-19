module IRT
  class Async
    def self.run
      hash = fetch
      Ability.async(hash)
    end

    private

    def self.fetch
      token  = ENV['IRT_TOKEN']
      uri    = URI.parse('http://localhost:13000/api/v1/auth/power?token=' + token)
      res    = Net::HTTP.get(uri)
      JSON.parse(res)['result']
    end
  end
end
