# frozen_string_literal: true

module Slack
  class UserDispatcher
    def self.new_register_notify(id)
      user = User.find(id)
      body = {
        username: 'User Dispatcher',
        attachments: [
          {
            color: :good,
            title: '新規登録通知',
            pretext: '_new register_',
            text: "現在の登録者数: #{User.count}人\n新規登録者: [#{user.iidxid}] #{user.djname} <#{User::Static::PREF[user.pref]}, #{User::Static::GRADE[user.grade]}>",
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end

    def self.delete_user_notify(id)
      user = User.find(id)
      body = {
        username: 'User Dispatcher',
        attachments: [
          {
            color: :danger,
            title: '削除通知',
            pretext: '_delete user_',
            text: "現在の登録者数: #{User.count - 1}人\n削除者: [#{user.iidxid}] #{user.djname} <#{User::Static::PREF[user.pref]}, #{User::Static::GRADE[user.grade]}>\n#{user.username}: #{user.email}",
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
