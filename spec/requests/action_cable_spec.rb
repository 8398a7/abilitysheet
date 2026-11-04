# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Action Cable', type: :request do
  it 'does not expose the unused subscription endpoint' do
    expect do
      get '/cable', {}, 'HTTP_CONNECTION' => 'Upgrade', 'HTTP_UPGRADE' => 'websocket'
    end.to raise_error(ActionController::RoutingError)
  end
end
