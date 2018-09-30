class ServiceDumper
  def dump_and_upload
    s3 = Aws::S3::Client.new
    file_open = File.open(dump)
    file_name = File.basename('service_dumper.tar.gz')
    begin
      Rails.logger.info('uploading s3...')
      s3.put_object(
        bucket: 'abilitysheet',
        body: file_open,
        key: "service_dumper/#{Date.today.year}-#{Date.today.month}-#{Date.today.day}/#{ENV['RAILS_ENV']}_#{file_name}"
      )
      Slack::S3Dispatcher.success(ENV['RAILS_ENV'])
    rescue StandardError => ex
      Slack::S3Dispatcher.failed(ENV['RAILS_ENV'], ex)
    end
    Rails.logger.info('done service dump')
  end

  private

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
    `cp -r #{files_path} #{dump_path}/uploads`
  end

  def pg_dump
    `pg_dump #{database} > #{dump_path}/#{database}.sql`
  end

  def dump_path
    "#{Rails.root}/tmp/service_dumper"
  end

  def database
    Rails.configuration.database_configuration[ENV['RAILS_ENV'] || 'production']['database']
  end

  def files_path
    "#{Rails.root}/public/uploads"
  end
end