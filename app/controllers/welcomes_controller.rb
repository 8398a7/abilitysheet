class WelcomesController < ApplicationController
  def list
    @users = User.all
    @color = %w(
      #ff8c00
      #fffacd
      #ff6347
      #afeeee
      #98fb98
      #9595ff
      #c0c0c0
      #ffffff
    )
  end

  def test
    reg = Scrape::Register.new
    @hoge = reg.get
  end
end
