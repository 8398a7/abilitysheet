# == Schema Information
#
# Table name: socials
#
#  id         :bigint(8)        not null, primary key
#  provider   :string
#  raw        :json
#  secret     :string
#  token      :string
#  uid        :string
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_socials_on_user_id_and_provider  (user_id,provider) UNIQUE
#

class Social < ApplicationRecord
end
