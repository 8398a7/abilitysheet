class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    sync_score
  end

  def destroy
    Slack::UserDispatcher.delete_user_notify(current_user.id)
    super
  end

  private

  def sync_score
    iidxid = env['rack.request.form_hash']['user']['iidxid']
    user_id = User.find_by(iidxid: iidxid).try(:id)
    return unless user_id
    Slack::UserDispatcher.new_register_notify(user_id)
    unless SidekiqDispatcher.exists?
      Slack::SidekiqDispatcher.notify
      return
    end
    ManagerWorker.perform_async(user_id)
    IidxmeWorker.perform_async(user_id)
  end
end
