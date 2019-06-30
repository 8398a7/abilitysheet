namespace :active_storage do
  desc "Migrates active storage local files to cloud"
    task migrate_local_to_cloud: :environment do
      require 'yaml'
      require 'erb'
      require 'google/cloud/storage'

      config_file = Pathname.new(Rails.root.join('config/storage.yml'))
      configs = YAML.load(ERB.new(config_file.read).result) || {}
      config = configs['google']

      client = Google::Cloud.storage(config['project'], config['credentials'])
      bucket = client.bucket(config.fetch('bucket'))

      ActiveStorage::Blob.find_each do |blob|
        key = blob.key
        folder = [key[0..1], key[2..3]].join('/')
        file_path = Rails.root.join('storage', folder.to_s, key)
        file = File.open(file_path, 'rb')
        md5 = Digest::MD5.base64digest(file.read)
        bucket.create_file(file, key, content_type: blob.content_type, md5: md5)
        file.close
        puts key
      end
    end
  end