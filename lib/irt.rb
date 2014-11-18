# data には [ユーザID, 単語ID, 知ってる(1)/知らない(0)] を格納。
# users/words は各IDをキー、重み(ユーザの語彙力/単語の難しさ)を値とするHash
class IRT
  def test
    p User.first
  end

  def work
    100.times do |k|
      eta = 1.0 / (k + 10) # 学習率(適当)
      e = 0
      data.sort_by { rand }.each do |user_id, word_id, t|
        z = users[user_id] - words[word_id]
        y = 1.0 / (1.0 + Math.exp(-z))      # ロジスティックシグモイド

        # (累積)誤差関数
        e -= if t == 1 then Math.log(y) else Math.log(1 - y) end

        grad_e_eta = eta * (y - t)   # 誤差関数の勾配
        users[user_id] -= grad_e_eta
        words[word_id] += grad_e_eta
      end
      puts "#{k}: #{e}"
    end
  end
end
