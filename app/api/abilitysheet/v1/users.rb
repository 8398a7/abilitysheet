module Abilitysheet::V1
  class Users < Grape::API
    resource :users do
      desc 'userの人数を取得'
      get '', jbuilder: 'users/index' do
        @count = User.select(:id).count
      end
    end
  end
end
