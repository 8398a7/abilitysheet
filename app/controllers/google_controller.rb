class GoogleController < ApplicationController
  before_action :authenticate_user!

  def destroy
    current_user.socials.find_by(provider: 'google_oauth2').destroy!
    redirect_to edit_user_registration_path
  end
end