module Abilitysheet::V1
  class Sheets < Grape::API
    resource :sheets do
      get '', jbuilder: 'sheets/index' do
        authenticate!
        unless current_user.admin?
          error! 'Forbidden', 403
          return
        end
        @sheets = Sheet.select(:id, :title, :n_ability, :h_ability, :version, :active, :textage)
      end
    end
  end
end
