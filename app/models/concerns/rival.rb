module Rival
  extend ActiveSupport::Concern

  included do
    def add_rival(r_iidxid)
      target = User.find_by(iidxid: r_iidxid)
      # 既にライバル登録していたら終了
      return false unless rival_overlap(rival, r_iidxid)
      # ライバルを10人以上登録できない
      return false unless count_rival
      # ライバルの逆ライバルに自身がいたら終了
      return false unless rival_overlap(target.reverse_rival, iidxid)

      init_array(target)
      # 自身のライバルと相手の逆ライバルを更新
      target.update(reverse_rival: target.reverse_rival.push(iidxid))
      update(rival: rival.push(r_iidxid))
      true
    end

    def remove_rival(r_iidxid)
      target = User.find_by(iidxid: r_iidxid)
      return false unless rival
      rival.delete(r_iidxid)
      save
      target.reverse_rival.delete(iidxid)
      target.save
    end

    private

    # 初期ではnilが入っているのでarrayを代入する必要がある
    def init_array(target)
      target.update(reverse_rival: []) unless target.reverse_rival
      update(rival: []) unless rival
    end

    def rival_overlap(arr, target_iidxid)
      return true unless arr
      return false if arr.include?(target_iidxid)
      true
    end

    def count_rival
      return true unless rival
      return false if 9 < rival.count
      true
    end
  end
end
