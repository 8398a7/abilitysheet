class RedisLibrary
  def self.set_recent200(user)
    redis = Redis.new
    recent200 = JSON.parse(redis.get(:recent200))
    recent200 = User.recent200 unless recent200.size == 200
    unless recent200.delete(user.id.to_s)
      last_key = nil
      recent200.each_key { |k| last_key = k }
      recent200.delete(last_key)
    end
    last_updated_score = user.scores.order(updated_at: :desc).first
    append_hash = {
      user.id => {
        id: user.id,
        djname: user.djname,
        iidxid: user.iidxid,
        pref: user.pref,
        grade: user.grade,
        updated_at: last_updated_score.updated_at.to_s.split.first,
        state: last_updated_score.state,
        title: last_updated_score.sheet.title
      }
    }
    # 今回追加されたユーザが先頭にが来るようにmerge
    redis.set(:recent200, append_hash.merge(recent200).to_json)
  end
end
