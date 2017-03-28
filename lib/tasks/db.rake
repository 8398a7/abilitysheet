# frozen_string_literal: true

namespace :db do
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
    Rake::Task['erd'].invoke if Rails.env.development?
    `bundle exec annotate` if Rails.env.development?
  end
end
