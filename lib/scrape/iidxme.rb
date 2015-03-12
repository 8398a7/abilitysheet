module Scrape
  class IIDXME
    def initialize
      @agent = Mechanize.new
    end

    def async(iidxid)
      process(iidxid)
    end

    private

    def user_id_search(iidxid)
      @agent.get("http://iidx.me/?name=#{ iidxid }")
      user_id_get(Nokogiri::HTML.parse(@agent.page.body, nil, 'UTF-8'))
    end

    def user_id_get(html)
      return false unless html.xpath('//table/tr').count == 2
      html.xpath('//table/tr')[1].xpath('td').xpath('a').first.attribute('href').value.gsub('/', '')
    end

    def process(iidxid)
      user_id = user_id_search(iidxid)
      return false unless user_id
      uri    = URI.parse("http://json.iidx.me/#{ user_id }/sp/level/12/")
      res    = Net::HTTP.get(uri)
      binding.pry
      JSON.parse(res)
    end
  end
end
