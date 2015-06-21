class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    @users = User.all
  end

  def call_back
    json = {}
    color = Static::COLOR
    users = User.where(id: JSON.parse(params[:id]))
    users.each do |user|
      score = user.scores.order(updated_at: :desc).find_by(state: 0..6)
      unless score
        json[user.id] = { title: '', stateColor: '', updatedAt: '' }
        next
      end
      score = score.decorate
      json[user.id] = {
        title: score.title,
        stateColor: color[score.state],
        updatedAt: "<a href=\"#{show_log_path(user.iidxid, score.updated_at.to_date.strftime)}\">#{score.updated_at}</a>"
      }
    end
    render json: json
  end
end
