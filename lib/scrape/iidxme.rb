module Scrape
  class IIDXME
    def initialize
      @agent = Mechanize.new
    end

    def async(iidxid)
      process(iidxid)
    end

    private

    def process(iidxid)
      return false unless User.exists?(iidxid: iidxid)
      elems = data_get(iidxid)
      return false unless elems
      user_id = User.find_by(iidxid: iidxid).id
      Score.iidxme_async(user_id, elems['musicdata'])
    end

    def search_api(iidxid)
      uri = URI.parse("http://json.iidx.me/?name=#{iidxid}")
      JSON.parse(Net::HTTP.get(uri))
    end

    def user_id_search(iidxid)
      return false unless iidxid =~ /\A\d{4}-\d{4}\z/
      hash = search_api(iidxid)
      return false unless hash['users'].count == 1
      hash['users'][0]['userid']
    end

    def data_get(iidxid)
      user_id = user_id_search(iidxid)
      return false unless user_id
      uri    = URI.parse("http://json.iidx.me/#{user_id}/sp/level/12/")
      res    = Net::HTTP.get(uri)
      JSON.parse(res)
    end
  end
end
