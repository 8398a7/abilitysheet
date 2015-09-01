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
        # TODO: elemsの要素検証をした方が良いかも
        # TODO: この辺りは今後はsidekiq処理にするべきかも
        elems.each do |e|
          score_params = { 'sheet_id' => e['id'], 'state' => e['cl'], 'score' => e['pg'] * 2 + e['g'], 'bp' => e['miss'] }
          score_params['score'] = nil if e['pg'] == -1 && e['g'] == -1
          score_params['bp'] = nil if e['miss'] == -1

          # スコアが理論値である場合の処理
          score_params['score'] = e['pg'] * 2 if e['pg'] != -1 && e['g'] == -1

          score = Score.find_by(user_id: current_user.id, sheet_id: e['id'])
          error! '404 Not Found', 404 unless score
          score.update_with_logs(score_params)
        end
        { status: 'ok' }
      end
    end
  end
end
