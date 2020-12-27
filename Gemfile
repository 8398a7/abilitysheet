# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# a,b,c,d,e,f,g {{{
gem 'bootsnap', require: false
gem 'coffee-rails'
gem 'devise'
gem 'draper'
gem 'google-cloud-storage'
# }}}
# h,i,j,k,l,m,n {{{
gem 'kaminari'
gem 'mini_magick'
gem 'nokogiri'
# }}}
# o,p,q,r,s,t,u {{{
gem 'oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'peek'
gem 'peek-gc'
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
gem 'sprockets', '3.7.2'
gem 'ts_routes'
gem 'turbolinks'
gem 'twitter'
# }}}
# v,w,x,y,z {{{
gem 'webpacker'
# }}}

group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'peek-git'
  gem 'rack-dev-mark'
  gem 'rails-erd', github: 'guapolo/rails-erd'
  gem 'spring'
  gem 'listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'json_expressions'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'spring-commands-rspec'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
