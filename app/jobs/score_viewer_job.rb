# frozen_string_literal: true

class ScoreViewerJob < ApplicationJob
  queue_as :score_viewer

  def perform(elems, id)
    user = User.find(id)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => score viewer import start)
    Score.api_score_viewer(elems, user)
    puts %(#{Time.zone.now} #{user.djname}[#{user.iidxid}] => score viewer import done)
  end
end
