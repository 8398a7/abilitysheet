require 'doorkeeper/grape/helpers'

module Abilitysheet::V1
  class Base < Grape::API
    use Rack::JSONP
    version 'v1', using: :path
    format :json

    helpers Doorkeeper::Grape::Helpers

    helpers do
      def authenticate!
        error!('Unauthorized.', 401) unless current_user
      end

      def warden
        env['warden']
      end

      def current_user
        warden.user
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
    mount Scores
    mount Messages
  end
end
