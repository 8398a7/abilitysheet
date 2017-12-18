# frozen_string_literal: true

class OfficialJob < ApplicationJob
  queue_as :official

  def perform(user_id, json)
    user = User.find(user_id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => official sync start)
    user.update_official(JSON.parse(json).deep_symbolize_keys)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => official sync done)
  end
end
