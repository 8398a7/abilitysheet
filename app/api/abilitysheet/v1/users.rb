module Abilitysheet::V1
  class Users < Grape::API
    resource :users do
      desc 'userのログイン状態を取得'
      get 'status' do
        { status: current_user.try(:iidxid) }
      end

      desc '自分の状態を取得'
      get 'me' do
        { current_user: current_user.try(:schema) }
      end

      desc 'userの登録者数を取得'
      get 'count' do
        { users: User.select(:id).count }
      end

      desc 'score viewerのデータをimport'
      params do
        requires :id, type: String, desc: 'iidxid'
        requires :state, type: String, desc: '楽曲情報'
      end
      post 'score_viewer' do
        status 202
        authenticate!
        error! '403 Forbidden', 403 if current_user.iidxid != params[:id]
        begin
          elems = JSON.parse(params[:state])
        rescue
          error! '400 Bad Request', 400
        end
        elems.each do |e|
          # パラメータが不足している
          error! '400 Bad Request', 400 if !e['id'] || !e['cl'] || !e['pg'] || !e['g'] || !e['miss']
          # パラメータに余分な物がある
          error! '400 Bad Request', 400 if 5 < e.size
          # 楽曲が存在していない
          error! '404 Not Found', 404 unless Sheet.exists?(id: e['id'])
        end
        unless Rails.env.test?
          sidekiq = SidekiqDispatcher.exists?
          error! '503 Service Unavailable', 503 unless sidekiq
        end
        ScoreViewerWorker.perform_async(elems, current_user.id)
        { status: 'ok' }
      end
      resource :routing do
        get do
          [Rails.application.routes.url_helpers.root_path, current_user.try(:iidxid)]
        end
      end
    end
  end
end
