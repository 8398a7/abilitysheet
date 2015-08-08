class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
      @scores_map = User.users_list(:rivals, @users)
    else
      uri    = URI.parse('http://localhost:8080/api/v1/users/recent200')
      res    = Net::HTTP.get(uri)
      @users = JSON.parse(res)
    end
  end
end
