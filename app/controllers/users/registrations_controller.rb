module Users
  class RegistrationsController < Devise::RegistrationsController
    after_action :score_create, only: [:create]

    def create
      count = User.all.count
      if 100 <= count
        flash[:alert] = '登録人数が上限に達しました，追加をお待ちください'
        redirect_to root_path
      end
      super
    end

    private

    def score_create
      iidxid = env['rack.request.form_hash']['user']['iidxid']
      return unless User.exists?(iidxid: iidxid)
      Score.score_create(iidxid)
    end
  end
end
