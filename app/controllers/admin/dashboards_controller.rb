# frozen_string_literal: true

class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def index
    @email = User.where.not(email: '').count
    @message = Message.where(state: false).count
    @user = User.where(current_sign_in_at: Date.today..Date.today + 1).count
  end
end
