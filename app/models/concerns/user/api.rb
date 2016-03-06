module User::API
  extend ActiveSupport::Concern

  included do
    def schema
      {
        id: id,
        iidxid: iidxid,
        role: role,
        djname: djname,
        grade: grade,
        pref: pref,
        image_url: image.url,
        created_at: created_at,
        follows: following.pluck(:iidxid),
        followers: followers.pluck(:iidxid)
      }
    end
  end
end
