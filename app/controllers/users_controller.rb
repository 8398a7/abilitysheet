class UsersController < ApplicationController
  def index
    @cnt = User.select(:id).count
    uri    = URI.parse('http://localhost:8080/api/v1/users/recent200')
    res    = Net::HTTP.get(uri)
    @users = JSON.parse(res)
  end
end
