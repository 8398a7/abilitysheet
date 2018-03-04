# frozen_string_literal: true

class SyncSheetsJob < ApplicationJob
  queue_as :sync

  def perform(date = Date.today - 2.days)
    client = IstClient.new
    sheets = client.get_sheets(
      q: {
        music_scores_play_type_status_eq: 0,
        music_scores_level_eq: 12,
        created_at_gteq: Date.today - 1.week
      }
    )
    sheets.each do |sheet|
      s = Sheet.find_by(title: sheet['title'])
      next if s
      Sheet.create!(
        title: sheet['title'],
        version: sheet['version_status_before_type_cast'],
        n_ability: Static::POWER.last[1],
        h_ability: Static::POWER.last[1],
        exh_ability: Static::EXH_POWER.last[1],
        textage: ''
      )
    end
  end
end
