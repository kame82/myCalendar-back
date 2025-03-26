require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require 'dotenv/load'

class GoogleCalendar
  def initialize
    calendar = Google::Apis::CalendarV3
    # カレンダー操作用のインスタンスを生成、@serviceとして投入
    @calendar = calendar::CalendarService.new
    # アプリケーションの名前を設定（GCPで設定したサービスアカウント名）
    @calendar.client_options.application_name = ENV['GOOGLE_CALENDAR_APPLICATION_NAME']
    # authorizeメソッド（Google::Auth::UserAuthorizer）から受け取った認証情報
    @calendar.authorization = authorize
    # 利用するカレンダーのID(GCPで設定したメールアドレス)を設定する
    @calendar_id = ENV['GOOGLE_CALENDAR_ID']
    puts "Google Calendar API initialized"
  end

  def authorize
    client_secret = ENV['GOOGLE_CALENDAR_SECRET']
    # 認証情報を取得し、credentialに格納
    credential = Google::Auth::ServiceAccountCredentials.make_creds(
      # json_ke_io: StringIO.new(client_secret),
      json_key_io: File.open(client_secret),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    )
    # アクセストークンを取得
    credential.fetch_access_token!
    # 認証情報を返す
    credential

    puts "Google Calendar API authorized"
  end

end

# クラスのインスタンスを作成し、メソッドを呼び出す
 GoogleCalendar.new
