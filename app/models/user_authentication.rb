require 'digest'
class UserAuthentication < ApplicationRecord
  def self.hash_token(token)
    Digest::SHA256.hexdigest(token)
  end

  encrypts :access_token #access_tokenを暗号化 (refresh_tokenは暗号化ではなくハッシュ化。再利用しないため)

  belongs_to :user, dependent: :destroy
end
