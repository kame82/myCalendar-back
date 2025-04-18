class GoogleCalendarsController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'googleauth'

  class GoogleCalendarService
    def initialize(user)
      @calendar = Google::Apis::CalendarV3::CalendarService.new
      if user.user_authentication.nil?
        raise "UserAuthentication is missing for user: #{user.id}"
      end
      @calendar.authorization =  user.user_authentication.access_token  ##-- あとでcurrent_userから取得するように修正.--##
      # アプリケーションの名前を設定（GCPで設定したサービスアカウント名）
      @calendar.client_options.application_name = ENV['GOOGLE_CALENDAR_APPLICATION_NAME']
      # 利用するカレンダーのID(GCPで設定したメールアドレス)を設定する
      @calendar_id = user.email
      # puts "Google Calendar API initialized"
    end

    def client
      @calendar
    end

    def read
      events = @calendar.list_events(@calendar_id,
      time_min: Time.new(2025,3,27).iso8601,
      time_max: Time.new(2025,3,28).iso8601,)
      events.items.each do |event|
        puts '-------------------------------'
        puts_event(event)
      end
    end

    def puts_event(event)
      puts "Event: #{event.summary}"
      puts "description: #{event.description}"
      puts "Start: #{event.start.date_time || event.start.date}"
      puts "End: #{event.end.date_time || event.end.date}"
      puts "reminders: #{event.reminders}"
    end
  end
end
