class WelcomesController < ApplicationController
  def index
    @update_logs = Notice.where(state: 0, active: true).limit(5).order(:created_at)
    @notices = Notice.where(state: 1, active: true).limit(5).order(:created_at)
  end

  def list
    @users = User.all
    @color = Score.list_color
  end

  def test
    reg = Scrape::Register.new
    @hoge = reg.get
  end
end
