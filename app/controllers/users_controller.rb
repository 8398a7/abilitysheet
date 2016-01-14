class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
      @scores_map = User.users_list(:rivals, @users)
    else
      @users = User.recent200.deep_symbolize_keys
    end
  end
end
