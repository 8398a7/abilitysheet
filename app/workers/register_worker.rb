class RegisterWorker
  include Sidekiq::Worker
  sidekiq_options queue: :register
  sidekiq_options retry: false

  def perform(id)
    user = User.find_by(id: id)
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => score init start)
    Score.score_create(user.iidxid)
    puts %(#{Time.now} #{user.djname}[#{user.iidxid}] => score init done)
  end
end
