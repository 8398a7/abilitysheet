module Slack
  class UserDispatcher
    def self.new_register_notify(id)
      user = User.find(id)
      body = {
        username: 'User Dispatcher',
        attachments: [
          {
            color: :good,
            title: '新規登録者',
            pretext: '_new register_',
            text: "現在の登録者: #{User.count}人\n新規登録者: [#{user.iidxid}] #{user.djname} <#{Static::PREF[user.pref]}, #{Static::GRADE[user.grade]}>",
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
