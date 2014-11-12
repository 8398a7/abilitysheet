module Scrape
  class Register
    def initialize
      @agent = Mechanize.new
      login
    end

    def get
      rival_page
      rival = @agent.page.links[64]
      rival
    end

    private

    def rival_page
      @agent.get('http://p.eagate.573.jp/game/2dx/22/p/rival/rival_search.html')
      @agent.page.encoding = 'UTF-8'
      form = @agent.page.form
      form.iidxid = '94999984'
      @agent.submit(form)
    end

    def login
      @agent.get('https://p.eagate.573.jp/gate/p/login.html?path=http%3A%2F%2Fp.eagate.573.jp%2Fgame%2F2dx%2F22%2Fp%2Frival%2Frival_list.html&___REDIRECT=1')
      @agent.page.encoding = 'UTF-8'
      datas = File.read("#{ Rails.root }/tmp/hoge").split(',')
      form = @agent.page.form_with method: 'POST'
      form.KID = datas[0]
      form.pass = datas[1].strip!
      @agent.submit(form)
    end
  end
end
