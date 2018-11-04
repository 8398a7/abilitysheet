# frozen_string_literal: true
# == Schema Information
#
# Table name: logs
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer
#  sheet_id     :integer
#  pre_state    :integer
#  new_state    :integer
#  pre_score    :integer
#  new_score    :integer
#  pre_bp       :integer
#  new_bp       :integer
#  version      :integer
#  created_date :date
#

FactoryBot.define do
  factory :log do
    version { Abilitysheet::Application.config.iidx_version }
    created_date { Date.today }
  end
end
