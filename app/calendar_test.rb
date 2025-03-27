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
    # puts "Google Calendar API initialized"
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
    puts "Google Calendar API authorized"
    credential

  end

  def read
    events = @calendar.list_events(@calendar_id,
    time_min: Time.new(2025,3,27).iso8601,
    time_max: Time.new(2025,3,28).iso8601,)

    puts events.items
    events.items.each do |event|
      puts '-------------------------------'
      puts_event(event)
    end
  end

  def puts_event(event)
    puts "id: #{event.id}"
    puts "summary: #{event.summary}"
    puts "description: #{event.description}"
    puts "color_id: #{event.color_id}"
    puts "Event: #{event.summary}"
    puts "Start: #{event.start.date_time || event.start.date}"
    puts "End: #{event.end.date_time || event.end.date}"
    puts "reminders: #{event.reminders}"
  end

  def create(summary: "無題", description: nil, location: nil, start_time: DateTime.now, end_time: DateTime.now + 1.0/24)
    event = set_event(summary, description, location, start_time, end_time)
    result = @calendar.insert_event(@calendar_id, event)
    puts "Event created: #{result.html_link}"
  end

  def update(event_id)
    event = set_event("Updated", "Updated" ,"Updated" ,DateTime.now + 1.0/24 ,DateTime.now + 2.0/24 )
    result = @calendar.update_event(@calendar_id, event_id, event)
  end

  def set_event(summary, description, location, start_time, end_time)
    Google::Apis::CalendarV3::Event.new(
      summary: summary,
      description: description,
      location: location,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time),
    )
  end

  def delete(event_id)
    @calendar.delete_event(@calendar_id, event_id)
  end

end
# クラスのインスタンスを作成し、メソッドを呼び出す
GoogleCalendar.new.read
# GoogleCalendar.new.create(summary: "テスト", description: "テスト", location: "テスト", start_time: DateTime.now, end_time: DateTime.now + 1.0/24)
