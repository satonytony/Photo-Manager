# == Attributes
# id              :integer   PK
# email           :string    NOT NULL, UNIQUE（保存時に小文字化・前後空白除去）
# password_digest :string    NOT NULL（has_secure_password がハッシュ化して保存）
# created_at      :datetime  NOT NULL
# updated_at      :datetime  NOT NULL
class User < ApplicationRecord
  # has_secure_password により以下のattributeが追加される
  # password              :string
  # password_confirmation :string
  has_secure_password

  has_many :photos, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email, presence: true
  validates :password, presence: true, on: :create
end
