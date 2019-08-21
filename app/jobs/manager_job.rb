# frozen_string_literal: true

require 'scrape/manager'

class ManagerJob < ApplicationJob
  queue_as :manager

  def perform(id)
    user = User.find(id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape start)
    scrape = Scrape::Manager.new(user)
    scrape.sync
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape done)
  end
end
