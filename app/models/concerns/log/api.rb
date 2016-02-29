module Log::API
  extend ActiveSupport::Concern
  included do
    def schema
      {
        id: id,
        state: new_state,
        title: title,
        created_date: created_date
      }
    end
  end
end
