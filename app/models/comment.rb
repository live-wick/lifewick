# == Schema Information
#
# Table name: comments
#
#  id         :bigint(8)        not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  strand_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_comments_on_strand_id  (strand_id)
#  index_comments_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (strand_id => strands.id)
#  fk_rails_...  (user_id => users.id)
#

class Comment < ApplicationRecord
  belongs_to :strand
  belongs_to :user
  has_one_attached :attachment, dependent: :destroy
end
