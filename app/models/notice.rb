# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  body       :string
#  state      :integer
#  active     :boolean          default(TRUE)
#  created_at :date
#

class Notice < ActiveRecord::Base
end
