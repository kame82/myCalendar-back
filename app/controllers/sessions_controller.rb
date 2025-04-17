class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    frontend_url = ENV['REACT_APP_API_URL']
    user_info = request.env['omniauth.auth']
    google_user_id = user_info['uid']
    provider = user_info['provider']
    token = generate_token_with_google_user_id(google_user_id, provider)
    access_token = user_info['credentials']['token']
    refresh_token = user_info['credentials']['refresh_token']

    # hashed_access_token = UserAuthentication.hash_token(access_token) #暗号化に切り替え
    hashed_refresh_token = UserAuthentication.hash_token(refresh_token) if refresh_token
    # p "-------------------------------------------"
    # p "google_image" => user_info['info']['image']
    # p "access_token: #{access_token}"
    # p "refresh_token: #{refresh_token}"
    # p "hashed_refresh_token: #{hashed_refresh_token}"
    # p "-------------------------------------------"

    user_authentication = UserAuthentication.find_by(uid: google_user_id, provider: provider)

    if user_authentication
      Rails.logger.info("User already exists")
      if refresh_token == nil
        Rails.logger.info("Refresh token is nil")
        user_authentication.update(access_token: access_token)
      else
        Rails.logger.info("Refresh token is exist")
        user_authentication.update(access_token: access_token, refresh_token: hashed_refresh_token)
      end

      redirect_to "#{frontend_url}/?token=#{token}",allow_other_host: true
    else
      Rails.logger.info("User does not exist")
      user = User.create(name: user_info['info']['name'], email:user_info['info']['email'], image: user_info['info']['image'])
      UserAuthentication.create( user_id: user.id, uid: google_user_id, provider: provider, access_token: access_token, refresh_token: hashed_refresh_token)
      redirect_to "#{frontend_url}/?token=#{token}", allow_other_host: true
    end
  end

  def destroy
  end

  private

  def generate_token_with_google_user_id(google_user_id, provider)
    exp = Time.now.to_i + 24 *3600
    payload = { google_user_id: google_user_id, provider: provider, exp: exp }
    hmac_secret = ENV['JWT_SECRET_KEY']
    JWT.encode( payload, hmac_secret, 'HS256' )
  end
end
