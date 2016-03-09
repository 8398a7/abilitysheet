class UsersController < ApplicationController
  def index
    @title = '最近更新した200人'
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
      @scores_map = User.users_list(:rivals, @users)
    else
      @users = User.recent200.deep_symbolize_keys
    end
  end

  def show
    @user = User.find_by_iidxid!(params[:id])
    # @spline = Log.spline(@user.id)
    @title = "DJ.#{@user.djname} プロフィール"
  end
end
