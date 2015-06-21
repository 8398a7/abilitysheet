class UsersController < ApplicationController
  before_action :load_users

  def index
    @cnt = User.select(:id).count
  end

  def call_back
    json = {}
    color = Static::COLOR
    @users.each do |user|
      score = user.scores.last_updated
      unless score
        json[user.id] = { title: '', stateColor: '', updatedAt: '' }
        next
      end
      score = score.decorate
      json[user.id] = {
        title: score.title,
        stateColor: color[score.state],
        updatedAt: "<a href=\"#{show_log_path(user.iidxid, score.updated_at)}\">#{score.updated_at}</a>"
      }
    end
    render json: json
  end

  private

  def load_users
    @users = User.all
  end
end
