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
        if user.admin? && user.valid_password?(params[:password])
          sheets = Sheet.all
          { result: sheets }
        else
          { result: %(User Error.) }
        end
      end
    end
  end
end
