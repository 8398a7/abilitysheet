Rails.application.routes.draw do
  devise_for :users

  root 'welcomes#index'
  get 'users/list' => 'welcomes#list', as: :list_welcomes
end
