# frozen_string_literal: true

namespace :db do
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
    `rails erd annotate_models` if Rails.env.development?
  end
end
