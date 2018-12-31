# == Schema Information
#
# Table name: attachments
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  strand_id   :bigint(8)
#
# Indexes
#
#  index_attachments_on_strand_id  (strand_id)
#
# Foreign Keys
#
#  fk_rails_...  (strand_id => strands.id)
#

require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
