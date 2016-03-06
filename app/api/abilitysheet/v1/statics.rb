module Abilitysheet::V1
  class Statics < Grape::API
    resources :statics do
      get do
        ret = []
        User::Static::GRADE.zip(User::Static::GRADE_COLOR).each do |grade, grade_color|
          ret.push(grade => grade_color)
        end
        { grade: ret, pref: User::Static::PREF }
      end
    end
  end
end
