source 'https://rubygems.org'

# consoleはpryを使う
gem 'pry-rails'

# viewはslimで
gem 'slim-rails'

# turbolinkを正しく動作させる
gem 'jquery-turbolinks'

# UI関連
gem 'twitter-bootstrap3-rails'
gem 'font-awesome-rails'

# dataTables利用
gem 'jquery-datatables-rails'

# 実行途中でpryの実行
gem 'pry-byebug'

# スクレイプ用
gem 'nokogiri'
gem 'mechanize'

# debug関係
group :development do
  gem 'rack-mini-profiler', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'rack-dev-mark'
end

# HighCharts
gem 'lazy_high_charts'

# crontab管理
gem 'whenever', require: false

# User管理
gem 'devise'
gem 'rails_admin'
gem 'cancan'
gem 'google-analytics-rails'

# db dump
gem 'yaml_db'

# deploy
group :deployment do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end

# sidekiq
gem 'sidekiq'
gem 'sinatra', require: false

# WebAPI
gem 'grape'
gem 'grape-jbuilder'

# twitter
gem 'twitter'

# RSpec
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end
gem 'codeclimate-test-reporter', group: :test, require: nil

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
# Use debugger
# gem 'debugger', group: [:development, :test]
