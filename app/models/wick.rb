# == Schema Information
#
# Table name: wicks
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)
#
# Indexes
#
#  index_wicks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Wick < ApplicationRecord
  belongs_to :user, optional: true

 	has_many :strands, dependent: :destroy
 	has_many :shares, as: :shareable, dependent: :destroy

  def strands_count
    self.strands.count
  end
end
