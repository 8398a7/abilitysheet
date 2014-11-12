class WelcomesController < ApplicationController
  def list
    @users = User.all
  end

  def test
    reg = Scrape::Register.new
    @hoge = reg.get
  end
end
