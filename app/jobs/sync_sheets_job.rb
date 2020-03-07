# frozen_string_literal: true

require 'ist_client'

class SyncSheetsJob < ApplicationJob
  queue_as :system

  def perform(date = Date.today - 2.days)
    client = IstClient.new
    sheets = client.get_musics(
      q: {
        charts_play_type_status_eq: 0,
        charts_level_eq: 12,
        charts_updated_at_gteq: date
      }
    )
    sheets.each do |sheet|
      sheet['charts'].each do |chart|
        title = sheet['title']
        title += '†' if chart['difficulty_type_status'] == 'LEGGENDARIA'
        s = Sheet.find_by(title: title)
        next if s

        Sheet.create!(
          title: title,
          version: sheet['version_status_before_type_cast'],
          n_ability: Static::POWER.last[1],
          h_ability: Static::POWER.last[1],
          exh_ability: Static::EXH_POWER.last[1],
          textage: ''
        )
      end
    end
    Sheet.apply_exh
  end
end
