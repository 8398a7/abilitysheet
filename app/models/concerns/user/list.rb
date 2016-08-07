# frozen_string_literal: true
module User::List
  extend ActiveSupport::Concern

  included do
    class << self
      def users_list(type, options = {})
        __send__(type, options)
      end

      def recent200
        query = 'SELECT '
        query += 'users.id,users.djname,users.iidxid,users.pref,users.grade,'
        query += 'scores.updated_at, scores.state, sheets.title '
        query += 'FROM users, scores, sheets '
        query += 'WHERE users.id = scores.user_id '
        query += 'AND scores.state != 7 '
        query += 'AND sheets.id = scores.sheet_id '
        query += 'ORDER BY scores.updated_at DESC LIMIT 6400'
        users = ActiveRecord::Base.connection.execute(query).to_a
        recent_users = []
        ret = {}
        users.each do |user|
          break if 200 <= recent_users.size
          next if recent_users.include?(user['id'])
          recent_users.push(user['id'])
          user['updated_at'] = user['updated_at'].split[0]
          ret[user['id']] = user
        end
        ret
      end

      private

      def rivals(users)
        scores_map = {}
        users.each { |user| scores_map[user.id] = user.scores.last_updated }
        scores_map
      end
    end
  end
end
