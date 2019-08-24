# frozen_string_literal: true

if Rails.env.development?
  RailsERD.load_tasks

  namespace :erd do
    task :load_models do
      say 'Loading application environment...'
      Rake::Task[:environment].invoke

      say 'Loading code in search of Active Record models...'
      Zeitwerk::Loader.eager_load_all
    end
  end
end
