# frozen_string_literal: true

module Slack
  class S3Dispatcher
    def self.success(env)
      body = {
        icon_emoji: ':aws_s3:',
        username: 'S3 Dispatcher',
        attachments: [
          {
            color: :good,
            title: 'backup success',
            pretext: '_AWS S3_',
            text: "#{Time.zone.now} #{env} backup success!",
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end

    def self.failed(env, ex)
      body = {
        icon_emoji: ':aws_s3:',
        username: 'S3 Dispatcher',
        attachments: [
          {
            color: :danger,
            title: 'backup failed',
            pretext: '_AWS S3_',
            text: "#{Time.zone.now} #{env} backup failed...\n#{ex}",
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
