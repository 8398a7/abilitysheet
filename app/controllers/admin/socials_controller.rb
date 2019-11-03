# frozen_string_literal: true

class Admin::SocialsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user!

  def index
    @q = Social.ransack(params[:q])
    @q.sorts = ['id desc'] if @q.sorts.empty?
    @socials = @q.result.page(params[:page])
  end

  def show
    @social = Social.find(params[:id])
  end
end
