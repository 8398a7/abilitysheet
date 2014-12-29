module Scrape
  class Official
    def initialize(user_id, id, pass)
      @user_id = user_id
      @base = 'http://p.eagate.573.jp/game/2dx/22/p/djdata/music.html'

      @agent = Mechanize.new
      url = 'https://p.eagate.573.jp/gate/p/login.html'
      @agent.get(url)
      @agent.page.encoding = 'UTF-8'
      @count = 0

      # ログイン処理
      form = @agent.page.form_with(method: 'POST')
      form.KID = id
      form.pass = pass
      @agent.submit(form)
    end

    def score_get
      21.downto(4) do |version|
        puts version
        # version管理
        url = @base + "?list=#{ version }&play_style=0&s=1&page=1#musiclist"
        @agent.get(url)

        # スコア取得処理
        speed_get version if version <= -1
        next if normal_get(version)
        return false
      end
      true
    end

    private

    def normal_get(version)
      page = 1
      while 1 > 0
        url = @base + "?list=#{ version }&play_style=0&s=1&page=#{ page }#musiclist"
        # 最後尾のページになったら次のバージョンへ
        check = @agent.get(url)
        data = check.body.kconv(Kconv::UTF8, Kconv::SJIS)
        html = Nokogiri::HTML.parse(data, nil, 'UTF-8')

        return true if html.to_s.index('データがみつかりません')

        # メンテナンスかIDPASSエラーなら何もせずに終了
        return false unless error_check(html)

        @agent.page.links.each do |link|
          title = error_title_check(link.text.to_s)
          element_get('http://p.eagate.573.jp' + link.href.to_s) if Sheet.exists?(title: title)
          element_get('http://p.eagate.573.jp' + link.href.to_s) if title.index('gigadelic') || title.index('Innocent Walls')
        end

        page += 1
      end
    end

    def element_get(url)
      # 指定URLを取得してUTF-8化
      page = @agent.get(url)
      data = page.body.kconv(Kconv::UTF8, Kconv::SJIS)
      html = Nokogiri::HTML.parse(data, nil, 'UTF-8')

      # 解析処理
      html.xpath('//div[@class="Rcont_box"]').each do |node|
        tmp_title = node.search('div/div[@class="music_info_td"]')
        tmp_score = node.search('td[@class="right_border"]')
        tmp_miss = node.search 'td[@class="right_border table_type_minfo_td2"]'
        lamp =  node.search 'td[@class="right_border"]/img'
        title = tmp_title.text.split('                                ')[1]
        # 一部例外タイトル処理
        title = error_title_check(title)

        # 12にハイパー譜面があるもの
        if title == 'gigadelic' || title == 'Innocent Walls'
          h_score, h_miss = tmp_score[4].text, tmp_miss[1].text
          pg, g = pg_s(h_score), g_s(h_score)
          title += '[H]'
          h_miss, pg, g = no_value(h_miss), no_value(pg), no_value(g)
          l_v = lamp_value(lamp_return(lamp[1].attribute('src').value))
          score = pg.to_i * 2 + g.to_i
          Score.official_create(title, score, h_miss, l_v, @user_id)
          @count += 1
        end

        title = 'gigadelic[A]' if title.index 'gigadelic'
        title = 'Innocent Walls[A]' if title.index 'Innocent Walls'

        # 通常のアナザー譜面の処理
        a_score, a_miss = tmp_score[5].text, tmp_miss[2].text
        pg, g = pg_s(a_score), g_s(a_score)
        l_v = lamp_value(lamp_return(lamp[2].attribute('src').value))

        pg, g, a_miss = no_value(pg), no_value(g), no_value(a_miss)
        score = pg.to_i * 2 + g.to_i
        Score.official_create(title, score, a_miss, l_v, @user_id)
        @count += 1
      end
    end

    def error_title_check(title)
      return '†渚の小悪魔ラヴリィ～レイディオ†(IIDX EDIT)' if title.index '渚'
      return 'キャトられ恋はモ～モク' if title.index 'キャトられ'
      return 'カゴノトリ～弐式～' if title.index 'カゴノトリ'
      return 'PARANOiA ～HADES～' if title.index 'HADES'
      return 'quell～the seventh slave～' if title.index 'quell'
      return '旋律のドグマ ～Misérables～' if title.index '旋律'
      title
    end

    def lamp_return(state)
      lamp = state.split('/')[7].split('.')[0]

      return 'FULL COMBO' if lamp == 'clflg7'
      return 'EX HARD CLEAR' if lamp == 'clflg6'
      return 'HARD CLEAR' if lamp == 'clflg5'
      return 'CLEAR' if lamp == 'clflg4'
      return 'EASY CLEAR' if lamp == 'clflg3'
      return 'ASSIST CLEAR' if lamp == 'clflg2'
      return 'FAILED' if lamp == 'clflg1'
      return 'NO PLAY' if lamp == 'clflg0'
    end

    def lamp_value(lamp)
      return 0 if lamp == 'FULL COMBO'
      return 1 if lamp == 'EX HARD CLEAR'
      return 2 if lamp == 'HARD CLEAR'
      return 3 if lamp == 'CLEAR'
      return 4 if lamp == 'EASY CLEAR'
      return 5 if lamp == 'ASSIST CLEAR'
      return 6 if lamp == 'FAILED'
      return 7 if lamp == 'NO PLAY'
    end

    def pg_s(str)
      tmp = str.split('(')
      return tmp[1].split('/')[0]
    end

    def g_s(str)
      tmp = str.split('(')
      g = tmp[1].split('/')[1].split(')')[0]
      g
    end

    def no_value(str)
      return -1 if str == '-'
      str
    end

    def error_check(html)
      all = html.xpath('//div').text
      return false if all.index('メンテナンス中') || all.index('ログインが必要です')
      true
    end
  end
end
