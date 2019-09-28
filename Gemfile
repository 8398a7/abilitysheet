# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# a,b,c,d,e,f,g {{{
gem 'activerecord-import'
gem 'bootsnap', require: false
gem 'coffee-rails'
gem 'devise'
gem 'dotenv-rails'
gem 'draper'
gem 'font-awesome-rails'
gem 'google-cloud-storage'
# }}}
# h,i,j,k,l,m,n {{{
gem 'kaminari'
gem 'mechanize'
gem 'mini_magick'
gem 'nokogiri'
# }}}
# o,p,q,r,s,t,u {{{
gem 'oauth2'
gem 'peek'
gem 'peek-gc'
gem 'ts_routes'
# NOTE: 1.3.1はassets:precompileでは解決できないclass構文が入るため上げられない
gem 'peek-performance_bar', '1.2.1'
gem 'peek-pg'
gem 'peek-rblineprof'
gem 'peek-redis'
gem 'peek-sidekiq'
gem 'pg'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rails'
gem 'rails_admin'
gem 'ransack'
gem 'react-rails'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-prometheus-exporter'
gem 'sidekiq-history'
gem 'sinatra'
gem 'slim-rails'
gem 'turbolinks'
gem 'twitter'
gem 'uglifier'
# }}}
# v,w,x,y,z {{{
gem 'webpacker'
# }}}

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'meta_request'
  gem 'peek-git'
  gem 'pry-stack_explorer'
  gem 'rack-dev-mark'
  gem 'rails-erd'
  gem 'spring'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter'
  gem 'factory_bot_rails'
  gem 'json_expressions'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'spring-commands-rspec'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
