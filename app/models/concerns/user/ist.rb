# frozen_string_literal: true

require 'ist_client'

module User::Ist
  extend ActiveSupport::Concern
  FROM_IST_TO_AB = {
    '旋律のドグマ～Miserables～' => '旋律のドグマ ～Misérables～',
    '火影' => '焱影'
  }.freeze
  SEARCH_PARAMS = {
    q: {
      chart_level_eq: 12,
      chart_play_type_status_eq: 0,
      version_eq: Abilitysheet::Application.config.iidx_version
    }
  }.freeze

  # FIXME: 米国などの見つからなかったやつは海外に全部まとめている
  def find_pref(pref)
    User::Static::PREF.index(pref) || 0
  end

  # NOTE: 見つからなかったやつは無段位
  def find_grade(grade)
    User::Static::GRADE.index(grade.split[1]) || User::Static::GRADE.size - 1
  end

  def update_user(user)
    old_djname = djname
    self.djname = old_djname unless update(djname: user['user_activity']['djname'])
    pref = find_pref(user['user_activity']['pref_status'])
    grade = find_grade(user['user_activity']['sp_grade_status'])
    update!(grade: grade, pref: pref)
    avatar.attach(io: URI.open(user['image_path']), filename: 'avatar.png') unless Rails.env.development?
  end

  def find_sheet_id(score, sheets)
    if score['title'] == 'gigadelic' || score['title'] == 'Innocent Walls'
      difficulty_type = score['difficulty_type_status'] == 'HYPER' ? '[H]' : '[A]'
      sheets[score['title'] + difficulty_type]
    elsif FROM_IST_TO_AB.key?(score['title'])
      sheets[FROM_IST_TO_AB[score['title']]]
    elsif score['difficulty_type_status'] == 'LEGGENDARIA'
      sheets[score['title'] + '†']
    else
      sheets[score['title']]
    end
  end

  included do
    def update_ist
      user = ist_client.get_user(iidxid)
      return false if user.dig('error') == 'Not Found'
      return false if user['iidxid'] != iidxid

      result = ist_client.get_scores(iidxid, SEARCH_PARAMS)
      return false if result.dig('error') == 'Not Found'

      update_user(user)

      sheets = Sheet.active.pluck(:title, :id).to_h
      result['scores'].each do |score|
        next if score['score'].zero?
        sheet_id = find_sheet_id(score, sheets)
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
