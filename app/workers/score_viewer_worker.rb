class ScoreViewerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :score_viewer
  sidekiq_options retry: false

  def perform(elems, id)
    current_user = User.find_by(id: id)
    puts %(#{Time.now} #{current_user.djname}[#{current_user.iidxid}] => score viewer import start)
    Score.api_score_viewer(elems, current_user)
    puts %(#{Time.now} #{current_user.djname}[#{current_user.iidxid}] => score viewer import done)
  end
end
