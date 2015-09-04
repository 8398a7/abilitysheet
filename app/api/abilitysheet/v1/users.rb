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
          score = Score.find_by(user_id: current_user.id, sheet_id: e['id'])
          error! '404 Not Found', 404 unless score
        end
        unless Rails.env.test?
          begin
            Process.getpgid(File.read("#{Rails.root}/tmp/pids/sidekiq.pid").chomp!.to_i)
          rescue
            error! '503 Service Unavailable', 503
          end
        end
        ScoreViewerWorker.perform_async(elems, current_user.id)
        { status: 'ok' }
      end
    end
  end
end
