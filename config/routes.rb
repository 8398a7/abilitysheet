# == Route Map
#
#                        Prefix Verb   URI Pattern                                       Controller#Action
#                               GET    /oauth/authorize/:code(.:format)                  doorkeeper/authorizations#show
#           oauth_authorization GET    /oauth/authorize(.:format)                        doorkeeper/authorizations#new
#                               POST   /oauth/authorize(.:format)                        doorkeeper/authorizations#create
#                               DELETE /oauth/authorize(.:format)                        doorkeeper/authorizations#destroy
#                   oauth_token POST   /oauth/token(.:format)                            doorkeeper/tokens#create
#                  oauth_revoke POST   /oauth/revoke(.:format)                           doorkeeper/tokens#revoke
#            oauth_applications GET    /oauth/applications(.:format)                     doorkeeper/applications#index
#                               POST   /oauth/applications(.:format)                     doorkeeper/applications#create
#         new_oauth_application GET    /oauth/applications/new(.:format)                 doorkeeper/applications#new
#        edit_oauth_application GET    /oauth/applications/:id/edit(.:format)            doorkeeper/applications#edit
#             oauth_application GET    /oauth/applications/:id(.:format)                 doorkeeper/applications#show
#                               PATCH  /oauth/applications/:id(.:format)                 doorkeeper/applications#update
#                               PUT    /oauth/applications/:id(.:format)                 doorkeeper/applications#update
#                               DELETE /oauth/applications/:id(.:format)                 doorkeeper/applications#destroy
# oauth_authorized_applications GET    /oauth/authorized_applications(.:format)          doorkeeper/authorized_applications#index
#  oauth_authorized_application DELETE /oauth/authorized_applications/:id(.:format)      doorkeeper/authorized_applications#destroy
#              oauth_token_info GET    /oauth/token/info(.:format)                       doorkeeper/token_info#show
#              new_user_session GET    /users/sign_in(.:format)                          devise/sessions#new
#                  user_session POST   /users/sign_in(.:format)                          devise/sessions#create
#          destroy_user_session DELETE /users/sign_out(.:format)                         devise/sessions#destroy
#                 user_password POST   /users/password(.:format)                         users/passwords#create
#             new_user_password GET    /users/password/new(.:format)                     users/passwords#new
#            edit_user_password GET    /users/password/edit(.:format)                    users/passwords#edit
#                               PATCH  /users/password(.:format)                         users/passwords#update
#                               PUT    /users/password(.:format)                         users/passwords#update
#      cancel_user_registration GET    /users/cancel(.:format)                           users/registrations#cancel
#             user_registration POST   /users(.:format)                                  users/registrations#create
#         new_user_registration GET    /users/sign_up(.:format)                          users/registrations#new
#        edit_user_registration GET    /users/edit(.:format)                             users/registrations#edit
#                               PATCH  /users(.:format)                                  users/registrations#update
#                               PUT    /users(.:format)                                  users/registrations#update
#                               DELETE /users(.:format)                                  users/registrations#destroy
#                   user_unlock POST   /users/unlock(.:format)                           devise/unlocks#create
#               new_user_unlock GET    /users/unlock/new(.:format)                       devise/unlocks#new
#                               GET    /users/unlock(.:format)                           devise/unlocks#show
#                          root GET    /                                                 welcomes#index
#                         users GET    /users(.:format)                                  users#index
#                          user GET    /users/:id(.:format)                              users#show
#                      messages POST   /messages(.:format)                               messages#create
#                   new_message GET    /messages/new(.:format)                           messages#new
#                   rails_admin        /admin/model                                      RailsAdmin::Engine
#                 sidekiq_admin        /admin/sidekiq/dashboard                          Sidekiq::Web
#              admin_dashboards GET    /admin/dashboards(.:format)                       admin/dashboards#index
#            active_admin_sheet POST   /admin/sheets/:id/active(.:format)                admin/sheets#active
#          inactive_admin_sheet POST   /admin/sheets/:id/inactive(.:format)              admin/sheets#inactive
#                  admin_sheets GET    /admin/sheets(.:format)                           admin/sheets#index
#                               POST   /admin/sheets(.:format)                           admin/sheets#create
#               new_admin_sheet GET    /admin/sheets/new(.:format)                       admin/sheets#new
#              edit_admin_sheet GET    /admin/sheets/:id/edit(.:format)                  admin/sheets#edit
#                   admin_sheet GET    /admin/sheets/:id(.:format)                       admin/sheets#show
#                               PATCH  /admin/sheets/:id(.:format)                       admin/sheets#update
#                               PUT    /admin/sheets/:id(.:format)                       admin/sheets#update
#                               DELETE /admin/sheets/:id(.:format)                       admin/sheets#destroy
#               lock_admin_user POST   /admin/users/:id/lock(.:format)                   admin/users#lock
#             unlock_admin_user POST   /admin/users/:id/unlock(.:format)                 admin/users#unlock
#              login_admin_user GET    /admin/users/:id/login(.:format)                  admin/users#login
#                   admin_users GET    /admin/users(.:format)                            admin/users#index
#                               POST   /admin/users(.:format)                            admin/users#create
#                new_admin_user GET    /admin/users/new(.:format)                        admin/users#new
#               edit_admin_user GET    /admin/users/:id/edit(.:format)                   admin/users#edit
#                    admin_user GET    /admin/users/:id(.:format)                        admin/users#show
#                               PATCH  /admin/users/:id(.:format)                        admin/users#update
#                               PUT    /admin/users/:id(.:format)                        admin/users#update
#                               DELETE /admin/users/:id(.:format)                        admin/users#destroy
#           start_admin_sidekiq POST   /admin/sidekiq/:id/start(.:format)                admin/sidekiq#start
#           admin_sidekiq_index GET    /admin/sidekiq(.:format)                          admin/sidekiq#index
#          active_admin_message POST   /admin/messages/:id/active(.:format)              admin/messages#active
#        inactive_admin_message POST   /admin/messages/:id/inactive(.:format)            admin/messages#inactive
#                admin_messages GET    /admin/messages(.:format)                         admin/messages#index
#                   admin_mails POST   /admin/mails(.:format)                            admin/mails#create
#                new_admin_mail GET    /admin/mails/new(.:format)                        admin/mails#new
#                    list_rival GET    /rival/list(.:format)                             rivals#list
#            reverse_list_rival GET    /rival/reverse_list(.:format)                     rivals#reverse_list
#                   clear_rival GET    /rival/clear/:id(.:format)                        rivals#clear
#                    hard_rival GET    /rival/hard/:id(.:format)                         rivals#hard
#                  remove_rival POST   /rival/remove/:id(.:format)                       rivals#remove
#                register_rival POST   /rival/register/:id(.:format)                     rivals#register
#                         sheet GET    /sheets/:iidxid/:type(.:format)                   sheets#show
#                    edit_score GET    /scores/:id/edit(.:format)                        scores#edit
#                         score PATCH  /scores/:id(.:format)                             scores#update
#                               PUT    /scores/:id(.:format)                             scores#update
#                      list_log GET    /logs/:id/list(.:format)                          logs#list
#                     sheet_log GET    /logs/:id/sheet(.:format)                         logs#sheet
#                   manager_log POST   /logs/:id/manager(.:format)                       logs#manager
#                    iidxme_log POST   /logs/:id/iidxme(.:format)                        logs#iidxme
#                      edit_log GET    /logs/:id/edit(.:format)                          logs#edit
#                           log PATCH  /logs/:id(.:format)                               logs#update
#                               PUT    /logs/:id(.:format)                               logs#update
#                               DELETE /logs/:id(.:format)                               logs#destroy
#                          logs GET    /logs/:id/:date(.:format)                         logs#show
#                    recommends GET    /recommends(.:format)                             recommends#index
#           api_v1_users_status GET    /api/v1/users/status(.:format)                    api/v1/users#status
#               api_v1_users_me GET    /api/v1/users/me(.:format)                        api/v1/users#me
#                        api_v1 PUT    /api/v1/users/change_rival/:iidxid(.:format)      api/v1/users#change_rival
#     api_v1_users_score_viewer POST   /api/v1/users/score_viewer(.:format)              api/v1/users#score_viewer
#               api_v1_messages GET    /api/v1/messages(.:format)                        api/v1/messages#index
#                               GET    /api/v1/logs/:iidxid/:year/:month(.:format)       api/v1/logs#full_calendar
#                               GET    /api/v1/logs/cal-heatmap/:iidxid(.:format)        api/v1/logs#cal_heatmap
#                               GET    /api/v1/logs/graph/:iidxid/:year/:month(.:format) api/v1/logs#graph
#                api_v1_statics GET    /api/v1/statics(.:format)                         api/v1/statics#index
#                 api_v1_sheets GET    /api/v1/sheets(.:format)                          api/v1/sheets#index
#                               POST   /api/v1/scores/sync/iidxme/:iidxid(.:format)      api/v1/scores#sync_iidxme
#                  abilitysheet GET    /abilitysheet(.:format)                           welcomes#migrate_domain
#                               GET    /abilitysheet/:p1(.:format)                       welcomes#migrate_domain
#                               GET    /abilitysheet/:p1/:p2(.:format)                   welcomes#migrate_domain
#                               GET    /abilitysheet/:p1/:p2/:p3(.:format)               welcomes#migrate_domain
#                          peek        /peek                                             Peek::Railtie
#
# Routes for RailsAdmin::Engine:
#   dashboard GET         /                                      rails_admin/main#dashboard
#       index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#         new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#      export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
# bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#        show GET         /:model_name/:id(.:format)             rails_admin/main#show
#        edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#      delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
# show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
#
# Routes for Peek::Railtie:
# results GET  /results(.:format) peek/results#show
#

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
      # scores
      post '/scores/sync/iidxme/:iidxid' => 'scores#sync_iidxme'
    end
  end
  # mount Abilitysheet::API => '/api'

  # TODO: support 1 year(start: 15/12/20)
  get '/abilitysheet', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1/:p2', to: 'welcomes#migrate_domain'
  get '/abilitysheet/:p1/:p2/:p3', to: 'welcomes#migrate_domain'

  mount Peek::Railtie => '/peek'
end
