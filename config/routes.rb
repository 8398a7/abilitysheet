Rails.application.routes.draw do
  get 'recommends/list'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  # all visitor
  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcome
  get '/messages' => 'welcomes#message', as: :message_welcome
  post '/messages' => 'welcomes#create_message', as: :create_message_welcome

  # admin
  get '/admins' => 'admins#index', as: :index_admins
  get '/admins/message/list' => 'admins#message_list', as: :message_list_admins
  post '/admins/message/:id' => 'admins#message_change', as: :message_change_admins
  get '/admins/register' => 'admins#new_sheet', as: :new_sheet_admins
  post '/admins/register' => 'admins#create_sheet', as: :create_sheet_admins
  get '/admins/notice' => 'admins#new_notice', as: :new_notice_admins
  post '/admins/notice' => 'admins#create_notice', as: :create_notice_admins
  mount RailsAdmin::Engine => '/admins/model', as: :rails_admin
  get '/admins/mail' => 'admins#new_mail', as: :new_mail_admins
  post '/admins/mail' => 'admins#create_mail', as: :create_mail_admins
  require 'sidekiq/web'

  AbilitysheetIidx::Application.routes.draw do
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/admins/sidekiq', as: :sidekiq_admin
    end
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
  get '/scores/:id.:format' => 'scores#attribute', as: :scores
  post '/scores/:id' => 'scores#update', as: :score
  patch '/scores/:id' => 'scores#update'

  # log
  get '/logs/:iidxid/graph' => 'logs#graph', as: :graph_logs
  get '/logs/:iidxid/list' => 'logs#list', as: :list_logs
  post '/logs/:iidxid/list' => 'logs#maneger', as: :maneger_logs
  post '/logs/:iidxid/iidxme' => 'logs#iidxme', as: :iidxme_logs
  get '/logs/:iidxid/sheet' => 'logs#sheet', as: :sheet_log
  get '/logs/:iidxid/:date' => 'logs#show', as: :show_log

  # recommends
  get '/recommends/list' => 'recommends#list', as: :list_recommends
  get '/recommends/integration' => 'recommends#integration', as: :integration_recommends

  # API
  mount API => '/'
end
