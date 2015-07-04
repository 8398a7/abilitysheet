module List
  extend ActiveSupport::Concern

  HOPE_USERS_COUNT = 200

  included do
    class << self
      def users_list(type, options = {})
        __send__(type, options)
      end

      private

      def rivals(users)
        scores_map = {}
        users.each { |user| scores_map[user.id] = user.scores.last_updated }
        scores_map
      end

      def users(_options)
        limit_count = 4000
        user_count = 0
        scores_count = Score.select(:id).count
        scores_map = {}
        while user_count < HOPE_USERS_COUNT && user_count < scores_count
          limit_count *= 1.2
          scores = Score.includes(:sheet).is_not_noplay.order(updated_at: :desc).limit(limit_count)
          scores_map = {}
          user_ids = []
          scores.each do |score|
            user_ids.push score.user_id
            scores_map[score.user_id] ||= score
            scores_map[score.user_id] = score if scores_map[score.user_id].updated_at < score.updated_at
          end
          user_ids.uniq!
          user_count = user_ids.count
        end
        user_ids.slice!(HOPE_USERS_COUNT, user_ids.count - 1)
        [scores_map, user_ids]
      end
    end
  end
end
