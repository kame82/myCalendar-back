class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    frontend_url = ENV['REACT_APP_API_URL']
    user_info = request.env['omniauth.auth']
    google_user_id = user_info['uid']
    provider = user_info['provider']
    token = generate_token_with_google_user_id(google_user_id, provider)

    user_authentication = UserAuthentication.find_by(uid: google_user_id, provider: provider)

    if user_authentication
      Rails.logger.info("User already exists")
      redirect_to "#{frontend_url}/?token=#{token}",allow_other_host: true
    else
      Rails.logger.info("User does not exist")
      user = User.create(name: user_info['info']['name'], email:user_info['info']['email'])
      UserAuthentication.create( user_id: user.id, uid: google_user_id, provider: provider)
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
