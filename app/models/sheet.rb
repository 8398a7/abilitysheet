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

  scope :active, (-> { where(active: true) })

  after_create :create_ability

  def create_ability
    d = 99.99
    Ability.create(
      sheet_id: id,
      fc: d, exh: d, h: d, c: d, e: d, aaa: d
    )
  end

  def n_ability_name
    Static::POWER.find { |_, index| n_ability == index }.dig(0)
  end

  def h_ability_name
    Static::POWER.find { |_, index| h_ability == index }.dig(0)
  end

  def exh_ability_name
    Static::EXH_POWER.find { |_, index| exh_ability == index }.dig(0)
  end

  def self.apply_exh
    Scrape::ExhCollector.new.get_sheet.each do |title, ability|
      sheet = Sheet.find_by(title: title)
      next unless sheet

      sheet.update(exh_ability: find_exh_ability_from_string(ability)[1])
    end
  end

  def self.find_exh_ability_from_string(ability_string)
    Static::EXH_POWER.find { |power| power[0] == ability_string } || [nil, -1]
  end

  def self.find_exh_ability_from_integer(ability_integer)
    Static::EXH_POWER.find { |power| power[1] == ability_integer } || [nil, -1]
  end
end
