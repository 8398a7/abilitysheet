Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # all visitor
  root 'welcomes#index'
  resources :users, only: [:index]
  resources :messages, only: [:new, :create]

  # admin
  require 'sidekiq/web'
  authenticate :user, -> (u) { u.admin? } do
    mount RailsAdmin::Engine => '/admin/model', as: :rails_admin
    mount Sidekiq::Web => '/admin/sidekiq/dashboard', as: :sidekiq_admin
  end
  namespace :admin do
    resources :sheets do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :users
    resources :sidekiq, only: [:index]
    resources :tweets, only: [:new, :create]
    resources :messages, only: [:index] do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :mails, only: [:new, :create]
  end

  # rival
  get '/rival/list' => 'rivals#list', as: :list_rival
  get '/rival/reverse_list' => 'rivals#reverse_list', as: :reverse_list_rival
  get '/rival/clear/:id' => 'rivals#clear', as: :clear_rival
  get '/rival/hard/:id' => 'rivals#hard', as: :hard_rival
  post '/rival/remove/:id' => 'rivals#remove', as: :remove_rival
  post '/rival/register/:id' => 'rivals#register', as: :register_rival

  # sheet
  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets
  get '/sheets/:iidxid/power' => 'sheets#power', as: :power_sheets

  # score
  resources :scores, only: [:edit, :update]

  # log
  get '/logs/:iidxid/graph' => 'logs#graph', as: :graph_logs
  get '/logs/:iidxid/list' => 'logs#list', as: :list_logs
  post '/logs/:iidxid/maneger' => 'logs#maneger', as: :maneger_logs
  post '/logs/:iidxid/iidxme' => 'logs#iidxme', as: :iidxme_logs
  post '/logs/:iidxid/update_official' => 'logs#update_official', as: :update_official_logs
  post '/logs/:iidxid/official' => 'logs#official', as: :official_logs
  get '/logs/:iidxid/sheet' => 'logs#sheet', as: :sheet_log
  get '/logs/:iidxid/:date' => 'logs#show', as: :show_log

  # recommends
  get '/recommends/list' => 'recommends#list', as: :list_recommends
  get '/recommends/integration' => 'recommends#integration', as: :integration_recommends

  # API
  mount API => '/'
end
