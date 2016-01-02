module User::Role
  extend ActiveSupport::Concern

  OWNER = 100
  ADMIN = 75
  MEMBER = 50
  SPECIAL = 25
  GENERAL = 0

  included do
    def owner?
      OWNER <= role
    end

    def admin?
      ADMIN <= role
    end

    def member?
      MEMBER <= role
    end

    def special?
      SPECIAL == role || Role::OWNER == role
    end
  end
end
