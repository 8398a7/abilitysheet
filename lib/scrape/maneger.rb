module Scrape
  class Maneger
    attr_reader :agent, :url
    def initialize(current_user)
      @agent = Mechanize.new
      @base = 'http://beatmania-clearlamp.com/'
      @url = []
      @current_user = current_user
      search
    end

    def sync
      go
    end

    private

    def maneger_register(title, state)
      return false unless Sheet.exists?(title: title)
      sheet_id = Sheet.find_by(title: title).id
      user_id = @current_user.id
      score = Score.find_by(user_id: user_id, sheet_id: sheet_id)
      return false if score.state <= state
      version = AbilitysheetIidx::Application.config.iidx_version
      Log.create(
        user_id: user_id, sheet_id: sheet_id,
        pre_state: score.state, new_state: state, version: version
      )
      score.state = state
      score.save
      true
    end

    def go(url = @url)
      # @urlがなければ収集終了
      return false if url.count == 0

      # 配列の数だけ収集
      url.each { |u| extract(u) }
      true
    end

    def folder_specific(html)
      data = nil
      html.xpath('//div[@class="list"]').each do |node|
        cnt = 0
        node.xpath('dl/dd[@class="level l12"]').each { |_| cnt += 1 }
        data = node if 150 < cnt
      end
      data
    end

    def data_shaping(data)
      data = data.to_s.split('</table>')
      elems = nil
      data.each do |d|
        next unless d.index('level l12')
        elems = d.split('</dl>')
      end
      elems
    end

    def extract(url)
      html = Nokogiri::HTML.parse(@agent.get(@base + url).body, nil, 'UTF-8')

      # Level12フォルダの特定
      data = folder_specific(html)
      return false unless data

      # HTMLを整形
      elems = data_shaping(data)
      return false unless elems

      # HTMLから曲名と状態を抽出し，登録する
      elems.each do |elem|
        break if elem.index('</div>')
        state = value(elem.split('<dt class="')[1].split('">')[0])
        title = title_check(elem.split('<dd class="musicName">')[1].split('</dd>')[0].strip)
        title = gigadelic_innocentwalls(title, elem)
        maneger_register(title, state.to_i)
      end
      true
    end

    def gigadelic_innocentwalls(title, e)
      return title if title != 'gigadelic' && title != 'Innocent Walls'
      if e.split('<dl class="')[1].split('">')[0].index('hyper')
        title += '[H]'
      else
        title += '[A]'
      end
      title
    end

    # クリアランプマネージャとの表記ゆれに対応
    def title_check(e)
      return e if Sheet.exists?(title: e)
      case e
      when %(ピアノ協奏曲第１番"蠍火") then e = %(ピアノ協奏曲第１番”蠍火”)
      when %(キャトられ 恋はモ～モク) then e = %(キャトられ恋はモ～モク)
      when %(†渚の小悪魔ラヴリィ〜レイディオ†(IIDX EDIT)) then e = %(†渚の小悪魔ラヴリィ～レイディオ†(IIDX EDIT))
      when %(疾風迅雷 †LEGGENDARIA) then e = %(疾風迅雷†LEGGENDARIA)
      when %(We're so Happy (P*Light Remix) IIDX Ver.) then e = %(We're so Happy (P*Light Remix) IIDX ver.)
      when %(Verflucht †LEGGENDARIA) then e = %(Verflucht†LEGGENDARIA)
      when %(Sigmund †LEGGENDARIA) then e = %(Sigmund†LEGGENDARIA)
      when %(invoker †LEGGENDARIA) then e = %(invoker†LEGGENDARIA)
      when %(Feel The Beat †LEGGENDARIA) then e = %(Feel The Beat†LEGGENDARIA)
      when %(Close the World feat.a☆ru †LEGGENDARIA) then e = %(Close the World feat.a☆ru†LEGGENDARIA)
      when %(Session 9-Chronicles-) then e = %(Session 9 -Chronicles-)
      when %(恋する☆宇宙戦争っ!!) then e = %(恋する☆宇宙戦争っ！！)
      when %(ワルツ第17番 ト短調"大犬のワルツ") then e = %(ワルツ第17番 ト短調”大犬のワルツ”)
      when %(Ancient Scapes †LEGGENDARIA) then e = %(Ancient Scapes†LEGGENDARIA)
      when %(Scripted Connection⇒A mix) then e = %(Scripted Connection⇒ A mix)
      when %(Colors(radio edit)) then e = %(Colors (radio edit))
      when %(EΛΠIΣ) then e = %(ΕΛΠΙΣ)
      when %(Timepiece phase II(CN Ver.)) then e = %(Timepiece phase II (CN Ver.))
      when %(Hollywood Galaxy (DJ NAGAI Remix)) then e = %(Hollywood Galaxy(DJ NAGAI Remix))
      when %(表裏一体！？怪盗いいんちょの悩み♥) then e = %(表裏一体！？怪盗いいんちょの悩み)
      end
      e
    end

    def value(e)
      hash = { 'FC' => 0, 'EX' => 1, 'H' => 2, 'C' => 3, 'E' => 4, 'A' => 5, 'F' => 6, 'NO' => 7 }
      hash[e]
    end

    def search(current_user = @current_user)
      # ユーザの探索
      @agent.get(@base + 'djdata/')
      @agent.page.encoding = 'UTF-8'
      form = @agent.page.forms[2]
      iidxid = current_user.iidxid.delete('-')
      form.searchWord = iidxid
      @agent.submit(form)

      # そのユーザのページのURLを配列に格納
      html = Nokogiri::HTML.parse(@agent.page.body, nil, 'UTF-8')
      html.xpath('//table/tbody/tr').each do |tr|
        cnt = 0
        tmp = ''
        tr.xpath('td').each do |td|
          tmp = td.to_s.split('a href="/')[1].split('"')[0] if cnt == 1
          tmp = '' if cnt == 6 && td.text != iidxid
          cnt += 1
        end
        @url.push(tmp + 'sp/') unless tmp == ''
      end
    end
  end
end
