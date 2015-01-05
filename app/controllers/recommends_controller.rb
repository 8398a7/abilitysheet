class RecommendsController < ApplicationController
  before_action :authenticate_user!
  def list
    @sheets = Sheet.all.preload(:static)
  end
end
