class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_one :user_authentication, dependent: :destroy
end
