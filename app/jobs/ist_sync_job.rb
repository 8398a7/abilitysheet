# frozen_string_literal: true

class IstSyncJob < ApplicationJob
  queue_as :ist

  def perform(user)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => ist sync start)
    user.update_ist
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => ist sync done)
  end
end
