Rails.application.routes.draw do
  get 'sheets/show'

  devise_for :users

  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcomes

  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets

  get '/scores/:id' => 'scores#attribute', as: :scores
end
