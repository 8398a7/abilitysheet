module Abilitysheet::V1
  class Users < Grape::API
    resource :users do
      desc 'userのログイン状態を取得'
      get 'status' do
        { status: current_user.try(:iidxid) }
      end

      desc 'score viewerのデータをimport'
      params do
        requires :id, type: String, desc: 'iidxid'
        requires :state, type: String, desc: '楽曲情報'
      end
      post 'score_viewer' do
        authenticate!
        error! '403 Forbidden', 403 if current_user.iidxid != params[:id]
        { status: 'ok' }
      end
    end
  end
end
