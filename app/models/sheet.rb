# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id         :integer          not null, primary key
#  title      :string
#  n_ability  :integer
#  h_ability  :integer
#  version    :integer
#  active     :boolean          default(TRUE), not null
#  textage    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sheet < ApplicationRecord
  has_many :scores
  has_many :logs
  has_one :ability

  delegate :e,   to: :ability
  delegate :c,   to: :ability
  delegate :h,   to: :ability
  delegate :exh, to: :ability
  delegate :fc,  to: :ability
  delegate :aaa, to: :ability

  include Sheet::API

  scope :active, -> { where(active: true) }

  after_create :create_ability

  def create_ability
    d = 99.99
    Ability.create(
      sheet_id: id,
      fc: d, exh: d, h: d, c: d, e: d, aaa: d
    )
  end
end
