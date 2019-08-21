# frozen_string_literal: true

require 'scrape/iidxme'

class IidxmeJob < ApplicationJob
  queue_as :iidxme

  def perform(id)
    user = User.find(id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => iidxme sync start)
    Scrape::Iidxme.new.sync(user.iidxid)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => iidxme sync done)
  end
end
