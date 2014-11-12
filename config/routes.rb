Rails.application.routes.draw do
  get 'sheets/show'

  devise_for :users

  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcome

  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets

  get '/scores/:id.:format' => 'scores#attribute', as: :scores
  post '/scores/:id' => 'scores#update', as: :score
  patch '/scores/:id' => 'scores#update'
end
