class Admin::TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def new
  end

  def create
    Notice::IIDX12.new.tweet(params[:body])
    flash[:notice] = "#{params[:body]}をツイートしました"
    redirect_to new_admin_tweet_path
  end
end
