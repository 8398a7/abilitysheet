# frozen_string_literal: true
# == Schema Information
#
# Table name: follows
#
#  id             :bigint(8)        not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: :user_id
  belongs_to :to_user, class_name: 'User', foreign_key: :target_user_id
end
