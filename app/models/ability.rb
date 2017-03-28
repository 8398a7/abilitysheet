# frozen_string_literal: true

# == Schema Information
#
# Table name: abilities
#
#  id         :integer          not null, primary key
#  sheet_id   :integer
#  fc         :float
#  exh        :float
#  h          :float
#  c          :float
#  e          :float
#  aaa        :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ability < ApplicationRecord
  belongs_to :sheet

  def self.sync(data)
    data.each do |d|
      find_by(sheet_id: d['sheet_id']).update(fc: d['fc'], exh: d['exh'], h: d['h'], c: d['c'], e: d['e'])
    end
  end
end
