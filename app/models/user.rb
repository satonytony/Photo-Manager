class User < ApplicationRecord
  has_secure_password
  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email, presence: true
  validates :password, presence: true, on: :create
end
