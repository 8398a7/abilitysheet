# frozen_string_literal: true

class Admin::SidekiqController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def index
    @sidekiq = SidekiqDispatcher.exists?
  end

  def start
    flash[:notice] = 'sidekiq start'
    SidekiqDispatcher.start!
    render :reload
  end
end
