# == Schema Information
#
# Table name: strands
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  end_date    :datetime
#  location    :string
#  source      :integer
#  start_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#  wick_id     :bigint(8)
#
# Indexes
#
#  index_strands_on_user_id  (user_id)
#  index_strands_on_wick_id  (wick_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (wick_id => wicks.id)
#

require 'test_helper'

class StrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
