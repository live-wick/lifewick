# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  alias                  :string
#  birth_date             :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  open                   :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  subscription_code      :string
#  user_name              :string
#  work                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_many :handshakes
	has_many :friends, :through => :handshakes
	has_many :shares
	has_many :receivers, :through => :shares
	has_many :senders, :through => :shares
	has_many :wicks, dependent: :destroy

	after_create :create_wick

	def create_wick
		self.wicks.create(name: "Home")
		wick = Wick.find_by_name("Lifewick")
		wick.shares.create(sender_id: wick.user_id, receiver_id: self.id)
	end
end
