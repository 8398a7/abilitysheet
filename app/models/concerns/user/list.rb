# frozen_string_literal: true

module User::List
  extend ActiveSupport::Concern

  included do
    class << self
      def users_list(type, options = {})
        __send__(type, options)
      end

      def recent200
        query = <<~EOF
          SELECT
          users.id, users.djname, users.iidxid, users.pref, users.grade,
          scores.updated_at, scores.state, sheets.title
          FROM users, scores, sheets
          WHERE users.id = scores.user_id
          AND scores.state != 7
          AND sheets.id = scores.sheet_id
          ORDER BY scores.updated_at DESC
          LIMIT 6400
        EOF
        query.chomp.tr("\n", ' ')
        users = ActiveRecord::Base.connection.execute(query.chomp.tr("\n", ' ')).to_a
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
