module IRT
  class Async
    def self.run
      hash = fetch
      Static.async(hash)
    end

    private

    def self.fetch
      token = YAML.load_file("#{Rails.root}/config/token.yml").symbolize_keys![:token]
      uri    = URI.parse('http://localhost:13000/api/v1/auth/power?token=' + token)
      res    = Net::HTTP.get(uri)
      JSON.parse(res)['result']
    end
  end
end
