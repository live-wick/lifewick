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
#  shareable_id   :bigint(8)
#
# Indexes
#
#  index_shares_on_shareable_type_and_shareable_id  (shareable_type,shareable_id)
#

class Share < ApplicationRecord
	belongs_to :shareable, polymorphic: true

	belongs_to :sender, :class_name => 'User'
	belongs_to :receiver, :class_name => 'User'

  scope :shared_user_wicks, -> (user_id) {where(sender_id: user_id, shareable_type: 'Wick')}
  scope :followed_user_wicks, -> (user_id) {where(receiver_id: user_id, shareable_type: 'Wick')}

  scope :shared_user_strands, -> (user_id) {where(sender_id: user_id, shareable_type: 'Strand')}
  scope :followed_user_strands, -> (user_id) {where(receiver_id: user_id, shareable_type: 'Strand')}
end
