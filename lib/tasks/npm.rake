namespace :npm do
  desc 'do install'
  task :init do
    sh 'npm init'
  end
  task :install do
    sh 'npm install'
  end
  task :resolve do
    resolve_asset_paths
  end

  def components_directory
    Rails.root.to_s + '/node_modules'
  end

  def resolve_asset_paths
    Dir["#{components_directory}/**/*.css"].each do |filename|
      contents = File.read(filename) if FileTest.file?(filename)
      url_regex = /url\((?!\#)\s*['"]?(?![a-z]+:)([^'"\)]*)['"]?\s*\)/

      next unless contents =~ url_regex
      directory_path = Pathname.new(File.dirname(filename))

      new_contents = contents.gsub(url_regex) do |match|
        relative_path = Regexp.last_match[1]
        image_path = directory_path.join(relative_path).cleanpath
        puts "#{match} => #{image_path}"
        "url(<%= asset_path '#{image_path}' %>)"
      end

      FileUtils.rm(filename)
      File.write(filename + '.erb', new_contents)
    end
  end
end
