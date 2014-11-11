class WelcomesController < ApplicationController
  def list
    @users = User.all
  end
end
