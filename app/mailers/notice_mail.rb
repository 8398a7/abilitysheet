class NoticeMail < ActionMailer::Base
  default from: 'abilitysheet@iidx12.tk'
  default to: '8398a7@gmail.com'

  def new_register(user_id)
    @user = User.find_by(id: user_id)
    @count = User.select(:id).count

    mail subject: '新規登録者'
  end

  def new_message(message_id)
    @message = Message.find_by(id: message_id)
    mail subject: '新規問合せ'
  end

  def warning_sidekiq
    mail subject: 'sidekiq down!'
  end

  def form_deal(email, subject, body)
    @body = body + "\r\n"
    @body += '---------------------------------------------------' + "\r\n"
    @body += '※ このメールアドレスには返信ができません．'
    mail to: email
    mail subject: subject
  end
end
