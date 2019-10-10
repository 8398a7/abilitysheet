# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)
#  sheet_id     :bigint(8)
#  pre_state    :integer
#  new_state    :integer
#  pre_score    :integer
#  new_score    :integer
#  pre_bp       :integer
#  new_bp       :integer
#  version      :integer
#  created_date :date
#
# Indexes
#
#  index_logs_on_created_date_and_user_id_and_sheet_id  (created_date,user_id,sheet_id) UNIQUE
#  index_logs_on_sheet_id                               (sheet_id)
#  index_logs_on_user_id                                (user_id)
#

FactoryBot.define do
  factory :log do
    version { Abilitysheet::Application.config.iidx_version }
    created_date { Date.today }
  end
end
