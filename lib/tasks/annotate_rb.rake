if Rails.env.development?
  require 'annotate_rb'
  AnnotateRb::Core.load_rake_tasks
end
