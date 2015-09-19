module IIDXME
  extend ActiveSupport::Concern

  included do
    def self.iidxme_async(user_id, elems)
      user = User.find_by(id: user_id)
      elems.each do |elem|
        title = gigadelic_innocentwalls(elem['data'])
        title = title_check(title)
        sheet = Sheet.find_by(title: title)
        next unless sheet
        state = reverse(elem['clear'])
        score = user.scores.find_by(sheet_id: sheet.id)
        iidxme_params = { 'sheet_id' => sheet.id, 'state' => score.state, 'score' => elem['score'], 'bp' => elem['miss'] }
        iidxme_params['state'] = state if state < score.state
        score.update_with_logs(iidxme_params)
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
      status[state].to_i
    end
  end
end
