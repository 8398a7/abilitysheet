# frozen_string_literal: true
module Scrape
  class IIDXME
    GRADE_MAX = 20

    def initialize
      @agent = Mechanize.new
      @iidxme_domain = 'https://iidx.me'
      @json_iidxme_domain = 'http://json.iidx.me'
    end

    def async(iidxid)
      process(iidxid)
    end

    private

    def download_profile_image(user)
      User.find(user.id).remove_image!
      file = open("#{@iidxme_domain}/userdata/copula/#{user.iidxid.delete('-')}/qpro.png?t=0")
      return nil if file.class != Tempfile
      file
    end

    def process(iidxid)
      return false unless User.exists?(iidxid: iidxid)
      elems = data_get(iidxid)
      return false unless elems
      user = User.find_by(iidxid: iidxid)
      user.update!(
        djname: elems['userdata']['djname'],
        grade: (elems['userdata']['spclass'] - GRADE_MAX).abs,
        image: download_profile_image(user)
      )
      Score.iidxme_async(user.id, elems['musicdata'])
    end

    def search_api
      uri = URI.parse("#{@json_iidxme_domain}/!/userlist")
      JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    end

    def user_id_search(iidxid)
      return false unless iidxid =~ /\A\d{4}-\d{4}\z/
      user = search_api[:users].find { |u| u[:iidxid] == iidxid }
      return user[:userid] if user
      user
    end

    def data_get(iidxid)
      user_id = user_id_search(iidxid)
      return false unless user_id
      uri    = URI.parse("#{@json_iidxme_domain}/#{user_id}/sp/level/12/")
      res    = Net::HTTP.get(uri)
      JSON.parse(res)
    end
  end
end
