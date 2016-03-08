# == Schema Information
#
# Table name: follows
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_follows_on_user_id_and_target_user_id  (user_id,target_user_id) UNIQUE
#

class Follow < ActiveRecord::Base
  belongs_to :user
end
