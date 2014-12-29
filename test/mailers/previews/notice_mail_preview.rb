# Preview all emails at http://localhost:3000/rails/mailers/notice_mail
class NoticeMailPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notice_mail/sendMail
  def sendMail
    NoticeMail.sendMail
  end

end
