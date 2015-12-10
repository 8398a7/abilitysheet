JsRoutes.setup do |config|
  config.prefix = '/abilitysheet' if Rails.env.staging? || Rails.env.production?
end
