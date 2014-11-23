class ManegerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maneger
  def perform(id)
    current_user = User.find_by(id: id)
    puts %(#{ Time.now} #{ current_user.djname }[#{ current_user.iidxid }] => maneger scrape start)
    scrape = Scrape::Maneger.new(current_user)
    scrape.sync
    puts %(#{ Time.now} #{ current_user.djname }[#{ current_user.iidxid }] => maneger scrape done)
  end
end
