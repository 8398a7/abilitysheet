# frozen_string_literal: true

module User::Api
  extend ActiveSupport::Concern

  included do
    def graph(start_month, end_month)
      categories = logs.create_between(start_month, end_month).map { |b| b[0].to_s.slice(0, 7) }
      column = logs.column(start_month, end_month)
      spline = logs.spline(start_month, end_month)
      {
        categories: categories,
        pie: scores.is_active.is_current_version.pie,
        column: column,
        column_max: column.flatten.max,
        spline: spline,
        spline_max: spline.flatten.max
      }
    end

    def schema
      image_url = avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_path(avatar, disposition: :inline, only_path: true) : nil
      {
        id: id,
        iidxid: iidxid,
        djname: djname,
        grade: grade,
        pref: pref,
        image_url: image_url,
        created_at: created_at,
        follows: follow_users.pluck(:iidxid),
        followers: follower_users.pluck(:iidxid)
      }
    end
  end
end
