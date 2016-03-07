class Api::V1::StaticsController < Api::V1::BaseController
  def index
    render json: {
      grade: User::Static::GRADE.zip(User::Static::GRADE_COLOR).map { |grade, grade_color| { grade => grade_color } },
      pref: User::Static::PREF
    }
  end
end
