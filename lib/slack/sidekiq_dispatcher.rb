module Slack
  class SidekiqDispatcher
    def self.notify
      body = {
        icon_emoji: ':sidekiq:',
        username: 'Sidekiq Dispatcher',
        attachments: [
          {
            color: :warning,
            title: 'Sidekiq down!',
            pretext: '_Sidekiq_',
            text: 'Please promptly restored.',
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
