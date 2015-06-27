class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
    else
      user_ids = Score.order(updated_at: :desc).pluck(:user_id).uniq
      user_ids.slice!(200, user_ids.count - 1)
      @users = User.where(id: user_ids)
    end
    @hoge = @users
  end

  def call_back
    json = {}
    color = Static::COLOR
    users = User.where(id: JSON.parse(params[:id]))
    users.each do |user|
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
end
