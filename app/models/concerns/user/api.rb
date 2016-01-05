module User::API
  extend ActiveSupport::Concern

  included do
    def schema
      {
        id: id,
        iidxid: iidxid,
        role: role,
        djname: djname
      }
    end
  end
end
