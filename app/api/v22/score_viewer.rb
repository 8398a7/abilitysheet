module V22
  class ScoreViewer < Grape::API
    prefix :api
    version %(v22), using: :path

    format :json
    default_format :json

    # for Grape::Jbuilder
    formatter :json, Grape::Formatter::Jbuilder

    post :score_viewer do
      user = User.find_for_authentication(username: params[:user])
      if user && user.valid_password?(params[:password])
        { result: user }
      else
        { result: %(User Error.) }
      end
    end
  end
end
