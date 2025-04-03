class ApplicationController < ActionController::API
  before_action :authenticate_request
  def health_check
    render json: { message: 'Hello World' }
    puts 'Hello World'
  end

  protected
  def authenticate_request
    header = request.headers['Authorization']
    if header.nil?
      Rails.logger.error "Authorization header is missing"
      render json: { errors: 'Authorization header is missing' }, status: :unauthorized
      return
    end

    header_token = header.split(' ').last if header

    hmac_secret= ENV['JWT_SECRET_KEY']
    begin
      @decoded = JWT.decode(header_token, hmac_secret, true, { algorithm: 'HS256' })[0]
      user_auth = UserAuthentication.find_by(uid: @decoded['google_user_id'],provider: @decoded['provider'])
      @current_user = user_auth.user if user_auth
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      Rails.logger.error "認証エラー：#{e.message}"
      render json: { errors: e.message }, status: :unauthorized
    end
  end

end
