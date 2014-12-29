module Users
  class RegistrationsController < Devise::RegistrationsController
    after_action :score_create, only: [:create]

    def create
      count = User.all.count
      if 10 <= count
        flash[:alert] = '登録人数が上限に達しました，追加をお待ちください'
        redirect_to root_path
        return
      end

      super
    end

    private

    def score_create
      iidxid = env['rack.request.form_hash']['user']['iidxid']
      return unless User.exists?(iidxid: iidxid)
      user_id = User.find_by(iidxid: iidxid).id
      # もし既に登録されていた場合はスコアを作らない
      return if Score.exists?(user_id: user_id)
      RegisterWorker.perform_async(user_id)
      NoticeMail.new_register(user_id).deliver
    end
  end
end
