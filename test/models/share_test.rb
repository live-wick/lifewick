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

require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
