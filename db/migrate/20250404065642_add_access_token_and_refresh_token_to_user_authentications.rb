class AddAccessTokenAndRefreshTokenToUserAuthentications < ActiveRecord::Migration[7.1]
  def change
    add_column :user_authentications, :access_token, :string
    add_column :user_authentications, :refresh_token, :string
  end
end
