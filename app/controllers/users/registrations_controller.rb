module Users
  class RegistrationsController < Devise::RegistrationsController
    after_action :score_create, only: [:create]
    before_action :exist_sidekiq, only: [:create]

    def create
      super
    end

    private

    def exist_sidekiq
      Process.getpgid(File.read("#{Rails.root}/tmp/pids/sidekiq.pid").chomp!.to_i)
    rescue
      NoticeMail.warning_sidekiq.deliver
      flash[:alert] = '何らかの不具合が生じています．管理人にお問い合わせください．(Twitter->@IIDX_12)'
      redirect_to new_user_registration_path
    end

    def score_create
      iidxid = env['rack.request.form_hash']['user']['iidxid']
      return unless User.exists?(iidxid: iidxid)
      user_id = User.find_by(iidxid: iidxid).id
      # もし既に登録されていた場合はスコアを作らない
      return if Score.exists?(user_id: user_id)
      RegisterWorker.perform_async(user_id)
      NoticeMail.new_register(user_id).deliver
      ManegerWorker.perform_in(30.second, user_id)
    end
  end
end
