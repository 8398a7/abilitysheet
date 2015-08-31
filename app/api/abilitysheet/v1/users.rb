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
        # elemsをscore_paramsとpg, gに分ける処理
        elems.each do |e|
          score_params = { 'sheet_id' => e['id'], 'state' => e['cl'], 'score' => e['pg'] * 2 + e['g'], 'bp' => e['miss'] }
          # TODO: 存在しないsheet_idを渡された時の例外処理
          score = Score.find_by(user_id: current_user.id, sheet_id: e['id'])
          score.update_with_logs(score_params)
        end
        { status: 'ok' }
      end
    end
  end
end
