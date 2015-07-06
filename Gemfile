source 'https://rubygems.org'

# consoleはpryを使う
gem 'pry-rails'

# viewはslimで
gem 'slim-rails'

# UI関連
gem 'font-awesome-rails'
gem 'uikit-sass-rails', git: 'git://github.com/8398a7/uikit-sass-rails'
gem 'active_link_to'
gem 'ransack'
gem 'draper'
gem 'select2-rails'
gem 'rack-mini-profiler', require: false
gem 'nprogress-rails'

# dataTables利用
gem 'jquery-datatables-rails'

# 実行途中でpryの実行
gem 'pry-byebug'

# スクレイプ用
gem 'nokogiri'
gem 'mechanize'

# debug関係
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'rack-dev-mark'
  gem 'annotate'
end

# HighCharts
gem 'lazy_high_charts'

# crontab管理
gem 'whenever', require: false

# User管理
gem 'devise'
gem 'rails_admin'
gem 'google-analytics-rails'

# db dump
gem 'yaml_db'

# deploy
group :deployment do
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
end

# sidekiq
gem 'sidekiq'
gem 'sinatra', require: false

# WebAPI
gem 'grape', git: 'git@github.com:intridea/grape.git'
gem 'grape-jbuilder'
gem 'grape-devise', git: 'https://github.com/pluff/grape-devise.git'
gem 'grape_logging'
gem 'rack-cors', require: 'rack/cors'

# twitter
gem 'twitter'

# RSpec
group :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'json_expressions'
  gem 'rubocop'
end
gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'dotenv-rails'

# errbit
gem 'airbrake'

# new_relic
gem 'newrelic_rpm'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# Use unicorn as the app server
gem 'unicorn'
gem 'unicorn-worker-killer'
