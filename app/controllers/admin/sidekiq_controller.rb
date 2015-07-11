class Admin::SidekiqController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def index
  end
end
