module Abilitysheet::V1
  class Sheets < Grape::API
    resource :sheets do
      get '', jbuilder: 'sheets/index' do
        doorkeeper_authorize!
        @sheets = Sheet.select(:id, :title, :n_ability, :h_ability, :version, :active, :textage)
      end
    end
  end
end
