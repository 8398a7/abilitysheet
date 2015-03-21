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
      elems = data_get(iidxid)
      return false unless elems
      user_id = User.find_by(iidxid: iidxid).id
      Score.iidxme_async(user_id, elems['musicdata'])
    end

    def user_id_search(iidxid)
      uri    = URI.parse("http://json.iidx.me/?name=#{ iidxid }")
      res    = Net::HTTP.get(uri)
      hash = JSON.parse(res)
      return false if hash['users'][0].nil?
      hash['users'][0]['userid']
    end

    def data_get(iidxid)
      user_id = user_id_search(iidxid)
      return false unless user_id
      uri    = URI.parse("http://json.iidx.me/#{ user_id }/sp/level/12/")
      res    = Net::HTTP.get(uri)
      JSON.parse(res)
    end
  end
end
