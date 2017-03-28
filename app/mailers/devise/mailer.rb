# frozen_string_literal: true

class Devise::Mailer < Devise.parent_mailer.constantize
  include Devise::Mailers::Helpers

  def reset_password_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts = {})
    return if record.email.empty?
    @token = token
    devise_mail(record, :unlock_instructions, opts)
  end

  def password_change(record, opts = {})
    devise_mail(record, :password_change, opts)
  end
end
