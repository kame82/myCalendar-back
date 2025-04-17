Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
  scope: 'userinfo.email, userinfo.profile, openid, https://www.googleapis.com/auth/calendar.events.owned',
  access_type: 'offline'
  # prompt: 'consent' #リフレッシュトークンを登録するとき、一時的に追加
end
OmniAuth.config.allowed_request_methods = [:post, :get]
