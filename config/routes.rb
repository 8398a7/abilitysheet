Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # all visitor
  root 'welcomes#index'
  resources :users, only: %i(index show)
  resources :messages, only: [:new, :create]

  # admin
  require 'sidekiq/web'
  authenticate :user, -> (u) { u.admin? } do
    mount RailsAdmin::Engine => '/admin/model', as: :rails_admin
    mount Sidekiq::Web => '/admin/sidekiq/dashboard', as: :sidekiq_admin
  end
  namespace :admin do
    resources :dashboards, only: :index
    resources :sheets do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :users do
      post :lock, on: :member
      post :unlock, on: :member
      get :login, on: :member
    end
    resources :sidekiq, only: :index do
      post :start, on: :member
    end
    resources :messages, only: :index do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :mails, only: %i(new create)
  end

  # rival
  get '/rival/list' => 'rivals#list', as: :list_rival
  get '/rival/reverse_list' => 'rivals#reverse_list', as: :reverse_list_rival
  get '/rival/clear/:id' => 'rivals#clear', as: :clear_rival
  get '/rival/hard/:id' => 'rivals#hard', as: :hard_rival
  post '/rival/remove/:id' => 'rivals#remove', as: :remove_rival
  post '/rival/register/:id' => 'rivals#register', as: :register_rival

  # sheet
  get '/sheets/:iidxid/:type' => 'sheets#show', as: :sheet

  # score
  resources :scores, only: %i(edit update)

  # log
  resources :logs, only: %i(edit update destroy) do
    get :list, on: :member
    get :sheet, on: :member
    post :manager, on: :member
    post :iidxme, on: :member
  end
  get '/logs/:id/:date' => 'logs#show', as: :logs

  # recommends
  resources :recommends, only: :index

  # API
  namespace :api do
    namespace :v1 do
      # users
      get '/users/status' => 'users#status'
      get '/users/me' => 'users#me'
      put '/users/change_rival/:iidxid' => 'users#change_rival'
      post '/users/score_viewer' => 'users#score_viewer'
      # messages
      resources :messages, only: :index
      # logs
      get '/logs/:iidxid/:year/:month' => 'logs#full_calendar'
      get '/logs/cal-heatmap/:iidxid' => 'logs#cal_heatmap'
      get '/logs/graph/:iidxid/:year/:month' => 'logs#graph'
      # statics
      resources :statics, only: :index
      # sheets
      resources :sheets, only: :index
      get '/sheets/list' => 'sheets#list'
      # scores
      get '/scores/:iidxid' => 'scores#show'
      get '/scores/:iidxid/:sheet_id' => 'scores#detail'
      put '/scores/:iidxid/:sheet_id/:state' => 'scores#update'
      post '/scores/sync/iidxme/:iidxid' => 'scores#sync_iidxme'
    end
  end

  # TODO: support 1 year(start: 15/12/20)
  get '/abilitysheet', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1/:p2', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1/:p2/:p3', to: 'welcomes#migrate_domain'

  mount Peek::Railtie => '/peek'
end
