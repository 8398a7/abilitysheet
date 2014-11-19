Dir.glob(File.join(Rails.root, 'db', 'seeds', 'score.rb')) do |file|
  load(file)
end
