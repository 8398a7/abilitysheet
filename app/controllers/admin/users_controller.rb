# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!
  before_action :check_xhr, except: %i[index login]
  before_action :load_user, except: %i[index new create]

  def index
    @search = User.search(params[:q])
    @users = @search.result
  end

  def new
    render :show_modal_form
  end

  def create
    @user = User.new(user_params)
    @user.save
    render :reload
  end

  def edit
    @check = @user.scores.is_active.select(:id).count == Sheet.active.select(:id).count ? true : false
    render :show_modal_form
  end

  def update
    @user.update_without_current_password(user_params)
    render :reload
  end

  def destroy
    @user.destroy
    render :reload
  end

  def lock
    @user.lock_access!
    render :reload
  end

  def unlock
    @user.unlock_access!
    render :reload
  end

  def login
    sign_out current_user
    sign_in @user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :iidxid, :username, :djname, :grade, :pref, :password
    )
  end

  def load_user
    return unless params[:id]
    @user = User.find_by(id: params[:id])
  end
end
