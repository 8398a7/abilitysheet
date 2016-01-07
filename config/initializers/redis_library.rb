redis = Redis.new
redis.set(:recent200, User.recent200.to_json)
