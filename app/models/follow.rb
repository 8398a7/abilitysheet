# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  target_user_id :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_follows_on_user_id_and_target_user_id  (user_id,target_user_id) UNIQUE
#

class Follow < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: :user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :target_user_id
end
