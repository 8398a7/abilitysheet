module Scrape
  class Official
    def initialize(user_id, id, pass)
      @user_id = user_id
      @base = %(http://p.eagate.573.jp/game/2dx/22/p/djdata/music.html)

      @agent = Mechanize.new
      url = %(https://p.eagate.573.jp/gate/p/login.html)
      @agent.get(url)
      @agent.page.encoding = %(UTF-8)
      @count = 0

      # ログイン処理
      form = @agent.page.form_with(method: 'POST')
      form.KID = id
      form.pass = pass
      @agent.submit(form)
    end

    def score_get
      recent = AbilitysheetIidx::Application.config.iidx_version - 1
      recent.downto(4) do |version|
        puts version
        # version管理
        url = @base + %(?list=#{ version }&play_style=0&s=1&page=1#musiclist)
        @agent.get(url)

        # スコア取得処理
        next if normal_get(version)
        return false
      end
      true
    end

    private

    def last_page_check(url)
      check = @agent.get(url)
      data = check.body.kconv(Kconv::UTF8, Kconv::SJIS)
      html = Nokogiri::HTML.parse(data, nil, 'UTF-8')

      return true if html.to_s.index('データがみつかりません')
    end

    def page_get
      @agent.page.links.each do |link|
        title = error_title_check(link.text.to_s)
        element_get('http://p.eagate.573.jp' + link.href.to_s) if Sheet.exists?(title: title) || title.index('gigadelic') || title.index('Innocent Walls')
      end
    end

    def normal_get(version)
      page = 1
      while 1 > 0
        url = @base + %(?list=#{ version }&play_style=0&s=1&page=#{ page }#musiclist)
        # 最後尾のページになったら次のバージョンへ
        return true if last_page_check(url)

        # メンテナンスかIDPASSエラーなら何もせずに終了
        return false unless error_check(html)

        page_get

        page += 1
      end
    end

    # no_value周り要修正
    def data_register(title, score, miss, l_v)
      pg, g = pg_s(score), g_s(score)
      miss, pg, g = no_value(miss), no_value(pg), no_value(g)
      score = pg.to_i * 2 + g.to_i
      Score.official_create(title, score, miss, l_v, @user_id)
      @count += 1
    end

    def data_parse(title, tmp_score, tmp_miss, lamp)
      hash = Hash.new(2)
      hash.store('gigadelic', 1)
      hash.store('Innocent Walls', 1)
      t = hash[title]
      score, miss = tmp_score[t + 3].text, tmp_miss[t].text
      l_v = lamp_return(lamp[t].attribute('src').value)
      title += '[H]' if t == 1
      data_register(title, score, miss, l_v)

      if t == 1
        title.gsub!('[H]', '[A]')
        data_parse(title, tmp_score, tmp_miss, lamp)
      end
      true
    end

    def html_parse(html)
      html.xpath('//div[@class="Rcont_box"]').each do |node|
        tmp_title = node.search('div/div[@class="music_info_td"]')
        tmp_score = node.search('td[@class="right_border"]')
        tmp_miss  = node.search('td[@class="right_border table_type_minfo_td2"]')
        lamp      = node.search('td[@class="right_border"]/img')
        # 一部例外タイトル処理
        title = error_title_check(tmp_title.text.split('                                ')[1])

        # データの処理
        data_parse(title, tmp_score, tmp_miss, lamp)
      end
    end

    def element_get(url)
      # 指定URLを取得してUTF-8化
      page = @agent.get(url)
      data = page.body.kconv(Kconv::UTF8, Kconv::SJIS)
      html = Nokogiri::HTML.parse(data, nil, 'UTF-8')

      # 解析処理
      html_parse(html)
    end

    def error_title_check(title)
      return %(†渚の小悪魔ラヴリィ～レイディオ†(IIDX EDIT)) if title.index('渚')
      return %(キャトられ恋はモ～モク)                      if title.index('キャトられ')
      return %(カゴノトリ～弐式～)                          if title.index('カゴノトリ')
      return %(PARANOiA ～HADES～)                          if title.index('HADES')
      return %(quell～the seventh slave～)                  if title.index('quell')
      return %(旋律のドグマ ～Misérables～)                 if title.index('旋律')
      title
    end

    def lamp_return(state)
      lamp = state.split('/')[7].split('.')[0]
      hash = {
        'clflg7' => 'FULL COMBO', 'clflg6' => 'EX HARD CLEAR',
        'clflg5' => 'HARD CLEAR', 'clflg4' => 'CLEAR',
        'clflg3' => 'EASY CLEAR', 'clflg2' => 'ASSIST CLEAR',
        'clflg1' => 'FAILED', 'clflg0' => 'NO PLAY'
      }
      lamp_value(hash[lamp])
    end

    def lamp_value(lamp)
      hash = {
        'FULL COMBO' => 0, 'EX HARD CLEAR' => 1, 'HARD CLEAR' => 2,
        'CLEAR' => 3, 'EASY CLEAR' => 4, 'ASSIST CLEAR' => 5,
        'FAILED' => 6, 'NO PLAY' => 7
      }
      hash[lamp]
    end

    def pg_s(str)
      tmp = str.split('(')
      tmp[1].split('/')[0]
    end

    def g_s(str)
      tmp = str.split('(')
      tmp[1].split('/')[1].split(')')[0]
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
