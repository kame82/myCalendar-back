require 'digest'
class UserAuthentication < ApplicationRecord
  def self.hash_token(token)
    Digest::SHA256.hexdigest(token)
  end

  belongs_to :user, dependent: :destroy
end
