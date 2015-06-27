class ManegerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maneger
  sidekiq_options retry: false

  def perform(id)
    user = User.find_by(id: id)
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => maneger scrape start)
    scrape = Scrape::Maneger.new(user)
    scrape.sync
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => maneger scrape done)
  end
end
