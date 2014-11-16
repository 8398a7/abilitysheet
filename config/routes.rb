Rails.application.routes.draw do
  get 'sheets/show'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcome

  get '/rival/list' => 'rivals#list', as: :list_rival
  get '/rival/reverse_list' => 'rivals#reverse_list', as: :reverse_list_rival
  get '/rival/clear/:id' => 'rivals#clear', as: :clear_rival
  get '/rival/hard/:id' => 'rivals#hard', as: :hard_rival
  post '/rival/remove/:id' => 'rivals#remove', as: :remove_rival
  post '/rival/register/:id' => 'rivals#register', as: :register_rival

  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets

  get '/scores/:id.:format' => 'scores#attribute', as: :scores
  post '/scores/:id' => 'scores#update', as: :score
  patch '/scores/:id' => 'scores#update'

  get '/logs/:iidxid/list' => 'logs#list', as: :list_logs
  get '/logs/:iidxid/sheet' => 'logs#sheet', as: :sheet_log
  get '/logs/:iidxid/:date' => 'logs#show', as: :show_log
end
