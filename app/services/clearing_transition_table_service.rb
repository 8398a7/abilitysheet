# frozen_string_literal: true

class ClearingTransitionTableService < ApplicationService
  def initialize(user)
    super()
    @user_id = user.id
  end

  def execute
    hash = {}
    sheets = Sheet.active.joins(:logs).select('sheets.title, logs.new_state, logs.created_date').where('logs.user_id = ? AND logs.new_state != logs.pre_state', @user_id)
    sheets.each do |sheet|
      hash[sheet.title] ||= {}
      next if hash[sheet.title][sheet.new_state] && hash[sheet.title][sheet.new_state] > sheet.created_date

      hash[sheet.title][sheet.new_state] = sheet.created_date
    end
    hash
  end
end
