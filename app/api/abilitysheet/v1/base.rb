module Abilitysheet::V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers Grape::Devise::Helpers
    include Grape::Devise::Endpoints

    helpers do
      def authenticate!
        error!('Unauthorized.', 401) unless current_user
      end
    end

    before do
      # authenticate!
    end

    mount Sheets
    mount Users
  end
end
