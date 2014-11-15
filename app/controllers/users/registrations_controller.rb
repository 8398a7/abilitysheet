module Users
  class RegistrationsController < Devise::RegistrationsController
    after_action :score_create, only: [:create]

    private

    def score_create
      iidxid = env['rack.request.form_hash']['user']['iidxid']
      return unless User.exists?(iidxid: iidxid)
      Score.score_create(iidxid)
    end
  end
end
