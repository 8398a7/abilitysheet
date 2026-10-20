# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint(8)        not null, primary key
#  body       :string
#  email      :string
#  ip         :inet             not null
#  user_id    :bigint(8)
#  state      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_messages_on_user_id  (user_id)
#

class Message < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[state]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  belongs_to :user, optional: true
end
