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
    @color = Static::COLOR
  end
end
