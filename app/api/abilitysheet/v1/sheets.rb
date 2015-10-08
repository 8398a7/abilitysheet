module Abilitysheet::V1
  class Sheets < Grape::API
    resource :sheets do
      get '' do
        { sheets: Sheet.order(:id) }
      end
    end
  end
end
