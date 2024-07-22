class User < ApplicationRecord
  has_many :diaries
  has_secure_password
  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
