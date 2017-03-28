# frozen_string_literal: true

module User::FollowMethods
  extend ActiveSupport::Concern
  included do
    def change_follow(target_user)
      following?(target_user.id) ? unfollow(target_user.iidxid) : follow(target_user.iidxid)
    end

    def following
      User.where(id: Follow.where(user_id: id).pluck(:target_user_id))
    end

    def followers
      User.where(id: Follow.where(target_user_id: id).pluck(:user_id))
    end

    def following?(user_id)
      following.pluck(:id).include?(user_id)
    end

    def follow(iidxid)
      target_user_id = User.select(:id).find_by(iidxid: iidxid).id
      return false if Follow.exists?(user_id: id, target_user_id: target_user_id)
      Follow.create(user_id: id, target_user_id: target_user_id)
      true
    end

    def unfollow(iidxid)
      target_user_id = User.select(:id).find_by(iidxid: iidxid).id
      return false unless Follow.exists?(user_id: id, target_user_id: target_user_id)
      Follow.find_by(user_id: id, target_user_id: target_user_id).destroy
      true
    end
  end
end
