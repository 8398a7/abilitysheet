# frozen_string_literal: true
class IidxmeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iidxme
  sidekiq_options retry: false

  def perform(id)
    user = User.find_by(id: id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => iidxme sync start)
    Scrape::IIDXME.new.sync(user.iidxid)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => iidxme sync done)
  end
end
