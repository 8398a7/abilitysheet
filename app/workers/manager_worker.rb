class ManagerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :manager
  sidekiq_options retry: false

  def perform(id)
    user = User.find_by(id: id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape start)
    scrape = Scrape::Manager.new(user)
    scrape.sync
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => manager scrape done)
  end
end
