# frozen_string_literal: true
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'p.eagate.573.jp'
    resource '*', headers: :any, methods: :post
  end
end
