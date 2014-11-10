Rails.application.routes.draw do
  devise_for :users

  root 'welcomes#index'
end
