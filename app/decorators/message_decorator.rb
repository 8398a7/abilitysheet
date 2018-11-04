# frozen_string_literal: true

class MessageDecorator < Draper::Decorator
  delegate_all

  def user_name
    return '匿名' unless object.user_id

    user = User.find_by(id: object.user_id)
    "#{user.djname}[#{user.iidxid}]"
  end

  def created_at
    object.created_at.strftime('%Y/%m/%d %H:%M')
  end

  def status
    object.state ? '既読' : '未読'
  end
end
