# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  n_ability   :integer
#  h_ability   :integer
#  version     :integer
#  active      :boolean          default(TRUE), not null
#  textage     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exh_ability :integer
#

FactoryBot.define do
  factory :sheet do
    title { 'MyString' }
    n_ability { 1 }
    h_ability { 1 }
    exh_ability { 1 }
    version { 1 }
    active { false }
    textage { 'MyString' }
  end
end
