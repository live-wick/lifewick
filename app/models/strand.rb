# == Schema Information
#
# Table name: strands
#
#  id             :bigint(8)        not null, primary key
#  address        :string
#  all_day        :boolean          default(FALSE)
#  description    :text
#  end_date       :datetime
#  is_event       :boolean          default(FALSE)
#  is_private     :boolean          default(FALSE)
#  is_public      :boolean          default(TRUE)
#  latitude       :string
#  longitude      :string
#  notes          :text
#  remind_me_on   :datetime
#  repeat_daily   :boolean          default(FALSE)
#  repeat_monthly :boolean          default(FALSE)
#  repeat_weekly  :boolean          default(FALSE)
#  repeat_yearly  :boolean          default(FALSE)
#  source         :integer
#  start_date     :datetime
#  title          :string
#  wick_name      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint(8)
#  wick_id        :bigint(8)
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

class Strand < ApplicationRecord
  belongs_to :user
  belongs_to :wick
 	has_many :shares, as: :shareable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :attachments, dependent: :destroy


end
