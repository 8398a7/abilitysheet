# frozen_string_literal: true

# == Schema Information
#
# Table name: scores
#
#  id         :bigint           not null, primary key
#  state      :integer          default(7), not null
#  score      :integer
#  bp         :integer
#  sheet_id   :bigint           not null
#  user_id    :bigint           not null
#  version    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :score do
    version { Abilitysheet::Application.config.iidx_version }
  end
end
