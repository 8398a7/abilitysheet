# frozen_string_literal: true
class ManagerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :manager
  sidekiq_options retry: false

  def perform(id)
    user = User.find(id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape start)
    scrape = Scrape::Manager.new(user)
    scrape.sync
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape done)
  rescue => e
    Airbrake.notify(e, user: user)
  end
end
