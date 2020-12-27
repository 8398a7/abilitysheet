# frozen_string_literal: true

require 'open-uri'

module Scrape
  class ExhCollector
    def initialize
      @url = 'https://www65.atwiki.jp/sp12ex-hard/pages/12.html'
    end

    def get_sheet
      text = URI.open(@url).read # rubocop:disable all
      html = Nokogiri::HTML.parse(text)
      parse(html)
    end

    private

    def parse(html)
      result = {}
      tables = html.xpath('//table')
      headers = html.xpath('//h2')
      tables.each_with_index do |table, index|
        header = headers[index + 1]
        table.children.each do |row|
          title = row.children[5]&.text
          next if title == '曲名'
          next unless title

          result[title] = header.text
        end
      end
      result
    end
  end
end
