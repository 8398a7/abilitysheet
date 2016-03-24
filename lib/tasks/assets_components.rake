namespace :assets do
  namespace :components do
    desc 'do install'
    task :install do
      Rails.application.config.assets.components.each do |component|
        sh "#{component} install"
      end
    end
    task :resolve do
      Rails.application.config.assets.paths.each do |components_directory|
        resolve_asset_paths(components_directory)
      end
    end

    def resolve_asset_paths(root_directory)
      Dir["#{root_directory}/**/*.css"].each do |filename|
        contents = File.read(filename) if FileTest.file?(filename)
        url_regex = /url\((?!\#)\s*['"]?(?![a-z]+:)([^'"\)]*)['"]?\s*\)/

        next unless contents =~ url_regex
        directory_path = Pathname.new(File.dirname(filename)).relative_path_from(Pathname.new(root_directory))

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
end
