module Score::ScoreViewer
  extend ActiveSupport::Concern

  included do
    def self.api_score_viewer(elems, current_user)
      elems.each do |e|
        score_params = { 'sheet_id' => e['id'], 'score' => e['pg'] * 2 + e['g'], 'bp' => e['miss'] }
        score_params['score'] = nil if e['pg'] == -1 && e['g'] == -1
        score_params['bp'] = nil if e['miss'] == -1

        # スコアが理論値である場合の処理
        score_params['score'] = e['pg'] * 2 if e['pg'] != -1 && e['g'] == -1

        score = current_user.scores.find_by(sheet_id: e['id'], version: Abilitysheet::Application.config.iidx_version)
        score = current_user.scores.create!(sheet_id: e['id'], version: Abilitysheet::Application.config.iidx_version) unless score

        score_params['state'] = score.state
        score_params['state'] = e['cl'] if e['cl'].to_i < score.state
        score.update_with_logs(score_params)
      end
    end
  end
end