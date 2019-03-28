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
#  mobile                 :string
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
	
  #  has_many :handshakes, dependent: :destroy
  # has_many :friends, :through => :handshakes, dependent: :destroy

	has_many :send_friend_requests, class_name: "Handshake", foreign_key: 'sender_id', dependent: :destroy
  has_many :received_friend_requests, class_name: "Handshake", foreign_key: 'receiver_id', dependent: :destroy

  has_many :shares, dependent: :destroy
	has_many :receivers, :through => :shares, dependent: :destroy
	has_many :senders, :through => :shares, dependent: :destroy

	has_many :wicks, dependent: :destroy
  has_many :additional_emails, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy


  validates_uniqueness_of :alias, :allow_blank => true, :allow_nil => true
	after_create :create_wick

  scope :all_except, ->(user) { where.not(id: user) }

	def create_wick
		self.wicks.create(name: "Home")
		wick = Wick.find_by_name("Lifewick")
		wick.shares.create(sender_id: wick.user_id, receiver_id: self.id)
	end

  
  def self.search_by_full_name(search)
    @names = search.split(" ")
    case @names.count
    when 2
      where("lower(first_name) LIKE :search1 AND lower(last_name) LIKE :search2", search1: "#{@names[0]}", search2: "#{@names[1]}")
    when 1
      where("lower(first_name) LIKE :search1 OR lower(last_name) LIKE :search1", search1: "#{@names[0].downcase}")
    else
      all
    end
  end
end
