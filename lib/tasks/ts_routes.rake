namespace :ts do
  TS_ROUTES_FILENAME = "#{Rails.root}/app/javascript/lib/routes.ts".freeze

  desc "Generate #{TS_ROUTES_FILENAME}"
  task routes: :environment do
    Rails.logger.info("Generating #{TS_ROUTES_FILENAME}")
    source = TsRoutes.generate(exclude: [/admin/, /active_storage/])
    File.write(TS_ROUTES_FILENAME, source)
  end
end
