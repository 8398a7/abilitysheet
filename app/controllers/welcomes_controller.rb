class WelcomesController < ApplicationController
  def list
    @users = User.all
    @color = Score.list_color
  end

  def test
    reg = Scrape::Register.new
    @hoge = reg.get
  end
end
