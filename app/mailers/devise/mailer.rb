class Devise::Mailer < Devise.parent_mailer.constantize
  include Devise::Mailers::Helpers

  # lock時にメールを送らない
  def unlock_instructions(_record, _token, _opts = {})
  end
end
