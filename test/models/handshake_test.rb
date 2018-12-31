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

require 'test_helper'

class HandshakeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
