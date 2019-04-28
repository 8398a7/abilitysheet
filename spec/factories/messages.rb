# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  body       :string
#  email      :string
#  ip         :inet             not null
#  user_id    :bigint
#  state      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :message do
    body { 'message' }
    ip { IPAddr.new('192.168.0.1') }
  end
end
