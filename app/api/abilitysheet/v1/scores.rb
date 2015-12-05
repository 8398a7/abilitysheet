module Abilitysheet::V1
  class Scores < Grape::API
    resources :scores do
      post 'official_sync' do
        authenticate!
        { result: :ok }
      end
    end
  end
end
