module Abilitysheet::V1
  class Scores < Grape::API
    resources :scores do
      params do
        requires :iidxid, type: String, desc: 'iidxid'
      end
      post 'sync/iidxme/:iidxid' do
        user = User.find_by(iidxid: params[:iidxid])
        error! '404 Not Found', 404 unless user
        IidxmeWorker.perform_async(user.id)
        { result: :ok }
      end
    end
  end
end
