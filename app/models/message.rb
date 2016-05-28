# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :string
#  email      :string
#  ip         :inet             not null
#  user_id    :integer
#  state      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  belongs_to :user
end
