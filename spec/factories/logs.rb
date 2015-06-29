# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sheet_id   :integer
#  pre_state  :integer
#  new_state  :integer
#  pre_score  :integer
#  new_score  :integer
#  pre_bp     :integer
#  new_bp     :integer
#  version    :integer
#  created_at :date
#

FactoryGirl.define do
  factory :log do
    version 22
  end
end
