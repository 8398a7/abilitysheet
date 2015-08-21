require 'doorkeeper/grape/helpers'

module Abilitysheet::V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    helpers Grape::Devise::Helpers
    include Grape::Devise::Endpoints
    helpers Doorkeeper::Grape::Helpers

    helpers do
      def authenticate!
        error!('Unauthorized.', 401) unless current_user
      end

      def current_resource_owner
        User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end

    before do
      # authenticate!
      # doorkeeper_authorize!
    end

    mount Sheets
    mount Users
  end
end
