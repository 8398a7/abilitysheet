# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def pref
    User::Static::PREF[object.pref]
  end

  def grade
    User::Static::GRADE[object.grade]
  end

  def belongs
    User::Static::PREF[object.pref]
  end

  def dan
    User::Static::GRADE[object.grade]
  end

  def joined_on
    "Joined on #{object.created_at.to_s.split.first.tr('-', '/')}"
  end

  def dan_color
    return '#afeeee' if object.grade >= 3 && object.grade <= 10
    return '#ff6347' if object.grade == 1 || object.grade == 2
    return '#ffd900' if object.grade.zero?

    '#98fb98'
  end

  def current
    return '未ログイン' unless object.current_sign_in_at

    "#{object.current_sign_in_at.strftime('%Y/%m/%d %H:%M')}/#{object.current_sign_in_ip}"
  end

  def last
    return '未ログイン' unless object.last_sign_in_at

    "#{object.last_sign_in_at.strftime('%Y/%m/%d %H:%M')}/#{object.last_sign_in_ip}"
  end
end
