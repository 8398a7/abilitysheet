class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
    else
      @scores_map, user_ids = User.users_list(:users)
      @users = User.where(id: user_ids)
    end
  end
end
