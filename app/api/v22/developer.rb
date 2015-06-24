module V22
  class Developer < Grape::API
    prefix :api
    version %(v22), using: :path

    format :json
    default_format :json

    # for Grape::Jbuilder
    formatter :json, Grape::Formatter::Jbuilder

    resource :developer do
      post :sheets do
        user = User.find_for_authentication(username: params[:user])
        if user.valid_password?(params[:password])
          if user.admin?
            sheets = Sheet.select(:id, :title, :n_ability, :h_ability, :version, :active, :textage)
            { result: sheets }
          else
            error! 'Forbidden', 403
          end
        else
          error! 'Unauthorized', 401
        end
      end

      post :users do
        count = User.select(:id).count
        { users: count }
      end
    end
  end
end
