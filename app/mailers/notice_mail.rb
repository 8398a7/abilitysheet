class NoticeMail < ActionMailer::Base
  default from: 'abilitysheet@iidx12.tk'

  def new_register(user_id)
    @user = User.find_by(id: user_id)
    @count = User.select(:id).count

    mail to: '8398a7@gmail.com'
    mail subject: '新規登録者'
  end

  def form_deal(email, subject, body)
    @body = body + "\r\n"
    @body += '---------------------------------------------------' + "\r\n"
    @body += '※ このメールアドレスには返信ができません．'
    mail to: email
    mail subject: subject
  end
end
