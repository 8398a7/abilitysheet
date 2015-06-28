class OfficialWorker
  include Sidekiq::Worker
  sidekiq_options queue: :official
  sidekiq_options retry: false

  def perform(id, k_id, k_pass)
    user = User.find_by(id: id)
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => official scrape start)
    scrape = Scrape::Official.new(id, k_id, k_pass)
    scrape.score_get
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => official scrape done)
  end
end
