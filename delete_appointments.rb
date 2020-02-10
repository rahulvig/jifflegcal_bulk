require "google/apis/calendar_v3"
require "date"
require "fileutils"
require 'time'
require 'pry'
require_relative 'google_authorize'

#code for deletion taken from https://developers.google.com/calendar/create-events

google_auth = GoogleAuthorize.new

APPLICATION_NAME = "Google Calendar API Ruby Delete Appointments".freeze



#Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = google_auth.authorize

calendar_id = "primary"
response = service.list_events(calendar_id,
                               max_results:   30000,
                               single_events: true,
                               order_by:      "startTime",
                               time_min:      DateTime.now.rfc3339,
                               time_max:      (DateTime.now + 90).rfc3339)
puts "No upcoming events found" if response.items.empty?
response.items.each do |event|
  unless event.i_cal_uid.include? "JIFFLENOW"
    puts "Deleted Meeting Subject- #{event.summary}"
    service.delete_event(calendar_id, event.id)
  end
end
