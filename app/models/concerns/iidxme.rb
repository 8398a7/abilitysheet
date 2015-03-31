module IIDXME
  extend ActiveSupport::Concern

  included do
    def self.iidxme_async(user_id, elems)
      scores = Score.where(user_id: user_id)
      elems.each do |elem|
        title = gigadelic_innocentwalls(elem['data'])
        title = title_check(title)
        next unless Sheet.find_by(title: title)
        sheet_id = Sheet.find_by(title: title).id
        state = reverse(elem['clear']).to_i
        next if scores.find_by(sheet_id: sheet_id).state <= state
        update(user_id, sheet_id, state)
      end
      true
    end

    def self.title_check(e)
      return e if Sheet.exists?(title: e)
      case e
      when %(キャトられ♥恋はモ～モク) then e = %(キャトられ恋はモ～モク)
      when %(旋律のドグマ～Misérables～) then e = %(旋律のドグマ ～Misérables～)
      when %(表裏一体！？怪盗いいんちょの悩み♥) then e = %(表裏一体！？怪盗いいんちょの悩み)
      end
      e
    end

    def self.gigadelic_innocentwalls(elem)
      title = elem['title']
      return title if title != 'gigadelic' && title != 'Innocent Walls'
      title += elem['diff'] == 'sph' ? '[H]' : '[A]'
      title
    end

    def self.reverse(state)
      status = %w(7 6 5 4 3 2 1 0)
      status[state]
    end
  end
end
