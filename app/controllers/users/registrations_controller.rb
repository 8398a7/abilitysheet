# frozen_string_literal: true

require 'slack/user_dispatcher'

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    render :new
  end

  def create
    respond_to do |format|
      format.html { render :new, status: :forbidden }
      format.any { head :forbidden }
    end
  end

  def destroy
    Slack::UserDispatcher.delete_user_notify(current_user.id)
    super
  end
end
