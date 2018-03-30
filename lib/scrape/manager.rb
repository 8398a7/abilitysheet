# frozen_string_literal: true

module Scrape
  class Manager
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

    def manager_register(title, state)
      return false unless Sheet.exists?(title: title)
      return false if state == 7
      sheet_id = Sheet.select(:id).find_by(title: title).id
      score = @current_user.scores.find_by(sheet_id: sheet_id, version: Abilitysheet::Application.config.iidx_version)
      score ||= @current_user.scores.create!(sheet_id: sheet_id, version: Abilitysheet::Application.config.iidx_version)
      return false if score.state <= state
      score.update_with_logs('sheet_id' => sheet_id, 'state' => state)
      true
    end

    def go(url = @url)
      # @urlがなければ収集終了
      return false if url.count.zero?

      # 配列の数だけ収集
      url.each { |u| extract(u) }
      true
    end

    def folder_specific(html)
      data = nil
      html.xpath('//div[@class="list"]').each do |node|
        cnt = 0
        node.xpath('dl/dd[@class="level l12"]').each { |_| cnt += 1 }
        data = node if cnt > 150
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
        preparation_register(elem)
      end
      true
    end

    def preparation_register(elem)
      state = value(elem.split('<dt class="')[1].split('">')[0])
      return false if state.nil?
      title = title_check(elem.split('<dd class="musicName">')[1].split('</dd>')[0].strip)
      title = gigadelic_innocentwalls(title, elem)
      manager_register(title, state.to_i)
    end

    def gigadelic_innocentwalls(title, elem)
      return title if title != 'gigadelic' && title != 'Innocent Walls'
      elem.split('<dl class="')[1].split('">')[0].index('hyper') ? title + '[H]' : title + '[A]'
    end

    # クリアランプマネージャとの表記ゆれに対応
    def title_check(elem)
      elem.gsub!('&amp;', '&')
      return elem if Sheet.exists?(title: elem)
      case elem
      when %(ピアノ協奏曲第１番"蠍火") then elem = %(ピアノ協奏曲第１番”蠍火”)
      when %(キャトられ 恋はモ～モク) then elem = %(キャトられ恋はモ～モク)
      when %(†渚の小悪魔ラヴリィ〜レイディオ†(IIDX EDIT)) then elem = %(†渚の小悪魔ラヴリィ～レイディオ†(IIDX EDIT))
      when %(疾風迅雷 †LEGGENDARIA) then elem = %(疾風迅雷†LEGGENDARIA)
      when %(We're so Happy (P*Light Remix) IIDX Ver.) then elem = %(We're so Happy (P*Light Remix) IIDX ver.)
      when %(Verflucht †LEGGENDARIA) then elem = %(Verflucht†LEGGENDARIA)
      when %(Sigmund †LEGGENDARIA) then elem = %(Sigmund†LEGGENDARIA)
      when %(invoker †LEGGENDARIA) then elem = %(invoker†LEGGENDARIA)
      when %(Feel The Beat †LEGGENDARIA) then elem = %(Feel The Beat†LEGGENDARIA)
      when %(Close the World feat.a☆ru †LEGGENDARIA) then elem = %(Close the World feat.a☆ru†LEGGENDARIA)
      when %(Session 9-Chronicles-) then elem = %(Session 9 -Chronicles-)
      when %(恋する☆宇宙戦争っ!!) then elem = %(恋する☆宇宙戦争っ！！)
      when %(ワルツ第17番 ト短調"大犬のワルツ") then elem = %(ワルツ第17番 ト短調”大犬のワルツ”)
      when %(Ancient Scapes †LEGGENDARIA) then elem = %(Ancient Scapes†LEGGENDARIA)
      when %(Scripted Connection⇒A mix) then elem = %(Scripted Connection⇒ A mix)
      when %(Colors(radio edit)) then elem = %(Colors (radio edit))
      when %(EΛΠIΣ) then elem = %(ΕΛΠΙΣ)
      when %(Timepiece phase II(CN Ver.)) then elem = %(Timepiece phase II (CN Ver.))
      when %(Hollywood Galaxy (DJ NAGAI Remix)) then elem = %(Hollywood Galaxy(DJ NAGAI Remix))
      when %(表裏一体！？怪盗いいんちょの悩み♥) then elem = %(表裏一体！？怪盗いいんちょの悩み)
      end
      elem
    end

    def value(elem)
      elem = 'N' if elem == 'NO'
      elem = 'EXH' if elem == 'EX'
      Static::LAMP_HASH[elem]
    end

    def search(current_user = @current_user)
      # ユーザの探索
      search_user(current_user)

      # そのユーザのページのURLを配列に格納
      html = Nokogiri::HTML.parse(@agent.page.body, nil, 'UTF-8')
      html.xpath('//table/tbody/tr').each do |tr|
        collect_user_page(tr)
      end
    end

    def collect_user_page(elem)
      cnt = 0
      tmp = ''
      elem.xpath('td').each do |td|
        tmp = td.to_s.split('a href="/')[1].split('"')[0] if cnt == 1
        tmp = '' if cnt == 6 && td.text != @iidxid
        cnt += 1
      end
      @url.push(tmp + 'sp/') unless tmp == ''
    end

    def search_user(current_user = @current_user)
      @agent.get(@base + 'djdata/')
      @agent.page.encoding = 'UTF-8'
      form = @agent.page.forms[2]
      @iidxid = current_user.iidxid.delete('-')
      form.searchWord = @iidxid
      @agent.submit(form)
    end
  end
end
