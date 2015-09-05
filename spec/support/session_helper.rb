module SessionHelpers
  def login(user, run_callbacks = false)
    login_as(user, scope: :user, run_callbacks: run_callbacks)
  end
end
