# frozen_string_literal: true

require 'slack/user_dispatcher'
require 'ist_client'

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    pre_user = User.select(:id).count
    super
    after_user = User.select(:id).count
    sync_score if pre_user < after_user
  end

  def destroy
    Slack::UserDispatcher.delete_user_notify(current_user.id)
    super
  end

  private

  def sync_score
    iidxid = request.env['rack.request.form_hash']['user']['iidxid']
    user = User.find_by(iidxid: iidxid)
    return unless user

    Slack::UserDispatcher.new_register_notify(user.id)

    user.check_ist_user
    IstSyncJob.perform_later(user)
  rescue IstClient::NotFoundUser
  end
end
