# frozen_string_literal: true

class Api::V1::HealthCheckController < Api::V1::BaseController
  def index
    ActiveRecord::Base.connection.execute('select 1')
    client = Redis.new(url: ENV['REDIS_URL'])
    client.ping
    render :ok
  end
end
