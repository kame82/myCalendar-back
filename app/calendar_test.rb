require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"

class GoogleCalendar
  def initialize
    Calendar = Google::Apis::CalendarV3
    @calendar = Calendar::CalendarService.new
    @calendar.client_options.application_name = ENV['GOOGLE_CALENDAR_APPLICATION_NAME']
    @calendar.authorization = authorize
    @calendar_id = ENV[GOOGLE_CALENDAR_ID]
  end

end
