# frozen_string_literal: true
module User::API
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

    def update_official(params)
      data = params[:scores].tr("\r", "\n").split("\n").map do |line|
        line.split(',')
      end
      header = data.shift
      puts header
      grade = User::Static::GRADE.index(params[:user][:grade])
      raise '[Official Update] No Grade' unless grade
      image = StringFileIO.create_from_canvas_base64(params[:user][:image])
      update!(grade: grade, djname: params[:user][:djname], image: image)
    end
  end
end
