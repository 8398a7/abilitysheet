Dir.glob(File.join(Rails.root, 'db', 'seeds', 'maneger.rb')) do |file|
  load(file)
end
