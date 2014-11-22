class ManegerWorker
  include Sidekiq::Worker
  def perform(user_id)
    current_user = User.find_by(id: user_id)
    scrape = Scrape::Maneger.new(current_user)
    result = scrape.sync
    result
  end
end
