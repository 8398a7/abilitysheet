# frozen_string_literal: true

module Scrape
  class IIDXME
    GRADE_MAX = 20

    def initialize
      @iidxme_domain = 'http://iidx.me'
      @result = {
        'userdata' => {
          'djname' => nil,
          'spclass' => nil
        },
        'musicdata' => [],
        'image' => nil
      }
    end

    def sync(iidxid)
      return unless ENV['iidxme'] == 'true'
      process(iidxid)
    end

    private

    def download_profile_image(elems, user)
      user.remove_image!
      file = open("#{@iidxme_domain}#{elems['userdata']['image']}") # rubocop:disable all
      return nil if file.class != Tempfile
      file
    end

    def process(iidxid)
      return false unless User.exists?(iidxid: iidxid)
      elems = get_data(iidxid)
      return false unless elems
      user = User.find_by(iidxid: iidxid)
      user.update!(
        djname: elems['userdata']['djname'],
        grade: (elems['userdata']['spclass'] - GRADE_MAX).abs,
        image: download_profile_image(elems, user)
      )
      Score.iidxme_sync(user.id, elems['musicdata'])
    end

    def search_api
      result = { users: [] }
      page = 1
      loop do
        break if page > 50
        html = parser("#{@iidxme_domain}/!/userlist?page=#{page}")
        break if html.xpath('//div[@class="table userlist"]/div').size == 1
        html.xpath('//div[@class="table userlist"]/div').each do |div|
          next if div.xpath('div[@class="td iidxid"]').empty?
          user_link = div.xpath('div[@class="td djname"]/div/a')[0]['href']
          result[:users].push(
            iidxid: div.xpath('div[@class="td iidxid"]').text.strip,
            userid: user_link[1..user_link.size]
          )
        end
        page += 1
      end
      result
    end

    def user_id_search(iidxid)
      return false unless iidxid.match?(/\A\d{4}-\d{4}\z/)
      user = search_api[:users].find { |u| u[:iidxid] == iidxid }
      return user[:userid] if user
      user
    end

    def parser(url)
      dom = Net::HTTP.get(URI.parse(url))
      Nokogiri::HTML.parse(dom, nil, 'UTF-8')
    end

    def get_userdata(user_id)
      html = parser("#{@iidxme_domain}/#{user_id}/sp/level/12")
      @result['userdata']['djname'] = html.xpath('//div[@class="djname"]').text.strip
      @result['userdata']['spclass'] = html.xpath('//div[@class="spclass"]/a')[0]['href'].split('?sp=')[1].to_i
      @result['userdata']['image'] = html.xpath('//div[@class="qpro"]/a/img')[0]['src']
      true
    end

    def diff(div)
      clear_and_type = div.xpath('div')[1].attr('class').split
      # %w[td level h lv12] or %w[td level a lv12]
      # 3番目のhやaの情報を返す
      clear_and_type[clear_and_type.size - 2] == 'h' ? 'sph' : 'spa'
    end

    def title(div)
      div.xpath('div[@class="td title"]').text
    end

    def score(div)
      score = div.xpath('div[@class="td score"]/div/span')[0]
      score ? score.text.to_i : nil
    end

    def clear(div)
      div.xpath('div[@class="td clear"]/div/a/span')[0]['class'].split[1].delete('clear').to_i || 0
    end

    def miss(div)
      miss = div.xpath('div[@class="td miss"]/div').text
      miss == '-' ? nil : miss.to_i
    end

    def get_data(iidxid)
      user_id = user_id_search(iidxid)
      return false unless user_id
      get_userdata(user_id)
      page = 1
      loop do
        break if page > 5
        html = parser("#{@iidxme_domain}/#{user_id}/sp/level/12?page=#{page}")
        break if html.xpath('//div[@class="table musiclist"]/div/div/div').text == 'NO RESULT'
        html.xpath('//div[@class="table musiclist"]/div').each do |div|
          next if div.xpath('div[@class="td title"]').empty?
          @result['musicdata'].push(
            'data' => {
              'title' => title(div),
              'diff' => diff(div)
            },
            'clear' => clear(div),
            'score' => score(div),
            'miss' => miss(div)
          )
        end
        page += 1
      end
      @result
    end
  end
end
