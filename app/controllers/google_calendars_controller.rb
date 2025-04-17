class GoogleCalendarsController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'googleauth'

  class GoogleCalendarService
    def initialize
      @client = Google::Apis::CalendarV3::CalendarService.new
      @client.authorization = user.google_oauth_token
    end
  end
end
