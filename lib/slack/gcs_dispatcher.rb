# frozen_string_literal: true

module Slack
  class GcsDispatcher
    def self.success(env)
      body = {
        icon_emoji: ':gcp_gcs:',
        username: 'GCS Dispatcher',
        attachments: [
          {
            color: :good,
            title: 'backup success',
            pretext: '_GCP GCS_',
            text: "#{Time.zone.now} #{env} backup success!",
            mrkdwn_in: %w[pretext]
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end

    def self.failed(env, exception)
      body = {
        icon_emoji: ':gcp_gcs:',
        username: 'GCS Dispatcher',
        attachments: [
          {
            color: :danger,
            title: 'backup failed',
            pretext: '_GCP GCS_',
            text: "#{Time.zone.now} #{env} backup failed...\n#{exception}",
            mrkdwn_in: %w[pretext]
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
