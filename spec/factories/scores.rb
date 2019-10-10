# frozen_string_literal: true

# == Schema Information
#
# Table name: scores
#
#  id         :bigint(8)        not null, primary key
#  state      :integer          default(7), not null
#  score      :integer
#  bp         :integer
#  sheet_id   :bigint(8)        not null
#  user_id    :bigint(8)        not null
#  version    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_scores_on_sheet_id                            (sheet_id)
#  index_scores_on_updated_at                          (updated_at)
#  index_scores_on_user_id                             (user_id)
#  index_scores_on_user_id_and_version_and_updated_at  (user_id,version,updated_at)
#  index_scores_on_version_and_sheet_id_and_user_id    (version,sheet_id,user_id) UNIQUE
#

FactoryBot.define do
  factory :score do
    version { Abilitysheet::Application.config.iidx_version }
  end
end
