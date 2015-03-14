class IidxmeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iidxme
  sidekiq_options retry: false

  def perform(id)
    user = User.find_by(id: id)
    puts %(#{ Time.now} #{ user.djname }[#{ user.iidxid }] => iidxme async start)
    Scrape::IIDXME.new.async(user.iidxid)
    puts %(#{ Time.now} #{ user.djname }[#{ user.iidxid }] => iidxme async done)
  end
end
