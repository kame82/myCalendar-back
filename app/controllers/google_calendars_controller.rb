class GoogleCalendarsController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'googleauth'
  # skip_before_action :authenticate_request # 確認用として一時的に追加
  before_action :set_calendar_service

  def read
    events = @calendar.list_events(@calendar_id,
    time_min: Time.new(2025,3,27).iso8601,
    time_max: Time.new(2025,3,28).iso8601,)

    event_data = events.items.map do |event|
      {
      summary: event.summary,
      description: event.description,
      start_time: event.start.date_time || event.start.date,
      end_time: event.end.date_time || event.end.date
    }
    end
    render json: event_data
  end

private
  def set_calendar_service
    user = @current_user
    if user.nil?
      raise Exceptions::UserNotFoundError.new(params[:user_id])
    end
    @calendar = Google::Apis::CalendarV3::CalendarService.new

    # if user.user_authentication.nil?
    #   raise Exceptions::MissingUserAuthenticationError.new(user.id)
    # end
    @calendar.authorization =  user.user_authentication.access_token
    # アプリケーションの名前を設定（GCPで設定したサービスアカウント名）
    @calendar.client_options.application_name = ENV['GOOGLE_CALENDAR_APPLICATION_NAME']
    # 利用するカレンダーのID(GCPで設定したメールアドレス)を設定する
    @calendar_id = user.email

    # puts "Google Calendar API initialized"
  end


end
