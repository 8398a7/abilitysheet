module Slack
  class MessageDispatcher
    def self.send(id)
      message = Message.find(id)
      user = message.user
      user_information = nil
      user_information = "#{user.djname}[#{user.iidxid}]" if user
      admin_messages_url = 'https://iidx12.tk/abilitysheet/admin/messages'
      body = {
        username: 'Message Dispatcher',
        attachments: [
          {
            color: '#439FE0',
            title: "#{message.ip} #{message.email} #{user_information}",
            title_link: admin_messages_url,
            pretext: '_Message_',
            text: message.body,
            mrkdwn_in: %w(pretext)
          }
        ]
      }
      Net::HTTP.post_form(Abilitysheet::Application::SLACK_URI, payload: body.to_json)
    end
  end
end
