# == Schema Information
#
# Table name: shares
#
#  id             :bigint(8)        not null, primary key
#  shareable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  receiver_id    :integer
#  sender_id      :integer
#  shareable_id   :integer
#

class Share < ApplicationRecord
	belongs_to :shareable, polymorphic: true

	belongs_to :sender, :class_name => 'User'
	belongs_to :receiver, :class_name => 'User'

  scope :shared_user_wicks, -> (user_id) {where(sender_id: user_id)}
  scope :followed_user_wicks, -> (user_id) {where(receiver_id: user_id)}
end
