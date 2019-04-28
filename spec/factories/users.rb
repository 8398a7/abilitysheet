# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  iidxid                 :string           not null
#  version                :integer          default(22), not null
#  djname                 :string           not null
#  grade                  :integer
#  pref                   :integer          not null
#  role                   :integer          default(0), not null
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@iidx.tk" }
    djname { 'TEST' }
    iidxid { '1234-5678' }
    grade { Abilitysheet::Application.config.iidx_grade }
    pref { 0 }
    username { 'test' }
    password { 'hogehoge' }
    role { 100 }
  end
end
