class Score < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
end
