# frozen_string_literal: true

require 'google/cloud/storage'

class ServiceDumper
  def dump_and_upload
    storage = Google::Cloud::Storage.new(
      project_id: 'iidx-app',
      credentials: "#{Rails.root}/service-dumper.json"
    )
    bucket = storage.bucket('iidx-app-service-dumper')
    Rails.logger.info('uploading gcs...')
    bucket.create_file(dump, upload_path)
    Slack::S3Dispatcher.success(ENV['RAILS_ENV'])
    `rm #{dump_path}.tar.gz`
    Rails.logger.info('done service dump')
  rescue StandardError => e
    Slack::S3Dispatcher.failed(ENV['RAILS_ENV'], e)
  end

  private

  def project_name
    'abilitysheet'
  end

  def upload_path
    "#{project_name}/#{Date.today.year}-#{Date.today.month}-#{Date.today.day}/#{ENV['RAILS_ENV']}_service_dumper.tar.gz"
  end

  def dump
    Rails.logger.info('clean dump path')
    `rm -rf #{dump_path}`
    Rails.logger.info('create dump path')
    `mkdir #{dump_path}`
    Rails.logger.info('file dumping...')
    file_dump
    Rails.logger.info('pg dumping...')
    pg_dump
    `echo #{Time.now} > #{dump_path}/info.txt`
    Rails.logger.info('tar.gz creating...')
    `cd #{Rails.root}/tmp && tar czf service_dumper.tar.gz service_dumper`
    Rails.logger.info('remove raw files')
    `rm -r #{dump_path}`

    "#{dump_path}.tar.gz"
  end

  def file_dump
    `cp -r #{files_path} #{dump_path}/storage`
  end

  def pg_dump
    `pg_dump -U#{database['username']} #{database['database']} > #{dump_path}/#{database['database']}.sql`
  end

  def dump_path
    "#{Rails.root}/tmp/service_dumper"
  end

  def database
    Rails.configuration.database_configuration[ENV['RAILS_ENV'] || 'production']
  end

  def files_path
    "/var/www/app/#{project_name}/shared/storage"
  end
end
