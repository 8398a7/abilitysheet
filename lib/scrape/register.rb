module Scrape
  class Register
    def initialize
      @agent = Mechanize.new
      @base = 'http://p.eagate.573.jp'
      login
    end

    def get
      rival_page_search
      # rival_page
    end

    private

    def rival_page
      # 0: DJNAME, 1: 所属, 2: 段位
      status = []
      page = @agent.get(@base + @agent.page.links[64].href)
      data = page.body.kconv(Kconv::UTF8, Kconv::SJIS)
      html = Nokogiri::HTML.parse(data, nil, 'UTF-8')
      table = ''
      html.xpath('//table[@class="status_type1"]').each { |n| table = n.to_s }
      status.push(table.split('<td>')[1].split('</td>')[0])
      status.push(table.split('<td>')[2].split('</td>')[0])
      status
    end

    def rival_page_search
      @agent.get('http://p.eagate.573.jp/game/2dx/22/p/rival/rival_search.html')
      @agent.page.encoding = 'UTF-8'
      form = @agent.page.form
      form.iidxid = '94999984'
      @agent.submit(form)
    end

    def login
      @agent.get('https://p.eagate.573.jp/gate/p/login.html?path=http%3A%2F%2Fp.eagate.573.jp%2Fgame%2F2dx%2F22%2Fp%2Frival%2Frival_list.html&___REDIRECT=1')
      @agent.page.encoding = 'UTF-8'
      datas = File.read("#{Rails.root}/tmp/auth").split(',')
      form = @agent.page.form_with method: 'POST'
      form.KID = datas[0]
      form.pass = datas[1].strip!
      @agent.submit(form)
    end
  end
end
