Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

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
    resources :dashboards, only: [:index]
    resources :sheets do
      post :active, on: :member
      post :inactive, on: :member
    end
    resources :users do
      post :lock, on: :member
      post :unlock, on: :member
    end
    resources :sidekiq, only: [:index] do
      post :start, on: :member
    end
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
  get '/sheets/:iidxid/:type' => 'sheets#show', as: :sheet

  # score
  resources :scores, only: [:edit, :update]

  # log
  resources :logs, only: [] do
    get :graph, on: :member
    get :list, on: :member
    get :sheet, on: :member
    post :official, on: :member
    post :manager, on: :member
    post :iidxme, on: :member
    post :update_official, on: :member
  end
  get '/logs/:id/:date' => 'logs#show', as: :log

  # recommends
  get '/recommends/list' => 'recommends#list', as: :list_recommends
  get '/recommends/integration' => 'recommends#integration', as: :integration_recommends

  # API
  mount Abilitysheet::API => '/api'
end
