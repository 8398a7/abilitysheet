class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user && user.admin?
    can :access, :rails_admin   # grant access to rails_admin
    can :manage, :all           # allow superadmins to do anything
  end
end
