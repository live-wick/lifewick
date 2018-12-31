# == Schema Information
#
# Table name: handshakes
#
#  id          :bigint(8)        not null, primary key
#  dtype       :string
#  notified    :boolean
#  result_date :date
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :integer
#  sender_id   :integer
#

class Handshake < ApplicationRecord
	belongs_to :user
  belongs_to :friend, :class_name => 'User'

end
