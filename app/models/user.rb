class User < ApplicationRecord
	has_many :handshakes
	has_many :friends, :through => :handshakes
end
