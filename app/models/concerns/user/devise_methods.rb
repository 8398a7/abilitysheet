# frozen_string_literal: true

module User::DeviseMethods
  extend ActiveSupport::Concern

  included do
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      if login
        find_by('username = :value OR iidxid = :value', value: login)
      else
        find_by(conditions)
      end
    end

    def update_without_current_password(params, *options)
      params.delete(:current_password)
      params.delete(:password) if params[:password].blank?
      params.delete(:password_confirmation) if params[:password_confirmation].blank?

      clean_up_passwords
      update_attributes(params, *options)
    end

    def email_required?
      false
    end

    def email_changed?
      false
    end
  end
end
