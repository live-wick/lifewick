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
	# belongs_to :user
  # belongs_to :friend, :class_name => 'User'

  belongs_to :sender_request_user, class_name: "User", foreign_key: 'sender_id'
  belongs_to :receiver_request_user, class_name: "User", foreign_key: 'receiver_id'

  scope :valid_handshakes, -> {where.not(status: -1)}


end
