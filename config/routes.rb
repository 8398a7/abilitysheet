# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # all visitor
  root 'welcomes#index'
  resources :users, only: %i(index show)
  resources :messages, only: [:new, :create]
  resources :helps, only: [] do
    collection do
      get :support
      get :ist
    end
  end

  # admin
  require 'sidekiq/web'
  authenticate :user, ->(u) { u.admin? } do
    mount RailsAdmin::Engine => '/admin/model', as: :rails_admin
    mount Sidekiq::Web => '/admin/sidekiq/dashboard', as: :sidekiq_admin
  end
  namespace :admin do
    resources :dashboards, only: :index
    post '/sheets/diff', to: 'sheets#diff'
    resources :sheets do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :users do
      post :lock, on: :member
      post :unlock, on: :member
      get :login, on: :member
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
  resources :rivals, only: [] do
    put 'reverse'
  end

  # sheet
  get '/sheets/:iidxid/:type' => 'sheets#show', as: :sheet

  # score
  resources :scores, only: %i(edit update)

  # log
  resources :logs, only: %i(edit update destroy) do
    get :list, on: :member
    get :sheet, on: :member
    post :ist, on: :member
  end
  get '/logs/:id/:date' => 'logs#show', as: :logs

  # recommends
  resources :recommends, only: :index

  # API
  namespace :api do
    namespace :v1 do
      resources :abilities, only: %i[index create]
      # users
      resources :users, only: [] do
        collection do
          get :status
          get :me
          put '/users/change_rival/:iidxid', to: 'users#change_rival'
        end
      end
      # messages
      resources :messages, only: :index
      # logs
      resources :logs, only: [], param: :iidxid do
        get :cal_heatmap
      end
      get '/logs/:log_iidxid/:year/:month' => 'logs#full_calendar'
      get '/logs/graph/:log_iidxid/:year/:month' => 'logs#graph'
      # statics
      resources :statics, only: :index
      # sheets
      resources :sheets, only: :index
      get '/sheets/list' => 'sheets#list'
      # scores
      resources :scores, only: :show, param: :iidxid
      get '/scores/:iidxid/:sheet_id' => 'scores#detail'
      put '/scores/:iidxid/:sheet_id/:state' => 'scores#update'

      post '/maintenance', to: 'maintenance#change'
      resources :health_check, only: :index
    end
  end

  mount Peek::Railtie => '/peek'
  mount Sidekiq::Prometheus::Exporter => '/sidekiq/metrics'
end
