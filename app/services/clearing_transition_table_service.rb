# frozen_string_literal: true

class ClearingTransitionTableService < ApplicationService
  def initialize(user)
    @user_id = user.id
  end

  def execute
    hash = {}
    sheets = Sheet.active.joins(:logs).select('sheets.title, logs.*').where('logs.user_id = ? AND logs.new_state != logs.pre_state', @user_id)
    sheets.each do |sheet|
      hash[sheet.title] ||= {}
      hash[sheet.title][sheet.new_state] = sheet.created_date
    end
    hash
  end
end
