# frozen_string_literal: true

module User::Ist
  extend ActiveSupport::Concern
  FROM_IST_TO_AB = {
    '旋律のドグマ～Miserables～' => '旋律のドグマ ～Misérables～',
    '火影' => '焱影',
    '炎影' => '焱影'
  }.freeze
  SEARCH_PARAMS = {
    q: {
      music_score_level_eq: 12,
      music_score_play_type_status_eq: 0,
      version_eq: Abilitysheet::Application.config.iidx_version
    }
  }.freeze

  included do
    def update_ist
      result = ist_client.get_scores(iidxid, SEARCH_PARAMS)
      return false if result.dig('error') == 'Not Found'

      sheets = Sheet.active.pluck(:title, :id).to_h
      result['scores'].each do |score|
        sheet_id = nil
        if score['title'] == 'gigadelic' || score['title'] == 'Innocent Walls'
          difficulty_type = score['difficulty_type_status'] == 'HYPER' ? '[H]' : '[A]'
          sheet_id = sheets[score['title'] + difficulty_type]
        elsif FROM_IST_TO_AB.key?(score['title'])
          sheet_id = sheets[FROM_IST_TO_AB[score['title']]]
        else
          sheet_id = sheets[score['title']]
        end
        # 削除曲だけunlessになる可能性がある
        next unless sheet_id

        scores.find_or_create_by!(
          sheet_id: sheet_id,
          version: Abilitysheet::Application.config.iidx_version
        ).update_with_logs(
          sheet_id: sheet_id,
          state: ::Static::LAMP_OFFICIAL.index(score['clear_type_status']),
          score: score['score'],
          bp: score['miss_count']
        )
      end
    end

    def ist_client
      IstClient.new
    end
  end
end
