module Abilitysheet::V1
  class Messages < Grape::API
    resource :messages do
      get '/number' do
        authenticate!
        error! '401 Unauthorized', 401 if current_user.role < User::Role::MEMBER
        { num: Message.where(state: false).count }
      end
    end
  end
end
