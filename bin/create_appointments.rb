require "google/apis/calendar_v3"
require "date"
require "fileutils"
require 'faker'
require 'yaml'
require 'time'
require_relative 'google_authorize'


google_auth = GoogleAuthorize.new

APPLICATION_NAME = "Google Calendar API Ruby create appointments".freeze

#code for recurrence creation taken from https://developers.google.com/calendar/create-events

 CONFIG = YAML.load_file('config.yaml')

#Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = google_auth.authorize


meeting_attendees = []

unless CONFIG['attendees'].empty?
  CONFIG['attendees'].each do |attendee_email|
  meeting_attendees << Google::Apis::CalendarV3::EventAttendee.new(
    email: attendee_email
    )
  end
end


start_date = Date.parse(CONFIG['start_date'])
end_date = Date.parse(CONFIG['end_date'])
days = (end_date - start_date).to_i

recurrence_pattern = ["RRULE:FREQ=DAILY;COUNT=#{days + 1}"]


#create single instances
(0..days).each do |i|
  meeting_date = (start_date + i).strftime('%Y-%m-%d')
  CONFIG['single_instance'].each do |start_time|
    formatted_start_time = Time.parse(start_time).strftime('%H:%M:%2N')
    end_time = (Time.parse(start_time) + 60 * CONFIG['meeting_duration'].to_i).strftime('%H:%M:%2N')
    event = Google::Apis::CalendarV3::Event.new(
      summary: Faker::Company.catch_phrase,
      location: Faker::Address.full_address,
      description: Faker::Company.bs,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: meeting_date + "T" + formatted_start_time,
        time_zone: CONFIG['time_zone']
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: meeting_date + "T" + end_time,
        time_zone: CONFIG['time_zone']
      ),
      attendees: meeting_attendees)


      result = service.insert_event('primary', event)
      puts "Event created: #{result.html_link}"
    end
  end

  #create recurrences
CONFIG['recurrence'].each do |start_time_recurrence|
  meeting_date = start_date.strftime('%Y-%m-%d')
  formatted_start_time_rec = Time.parse(start_time_recurrence).strftime('%H:%M:%2N')
  end_time_rec = (Time.parse(start_time_recurrence) + 60 * CONFIG['meeting_duration'].to_i).strftime('%H:%M:%2N')
  event = Google::Apis::CalendarV3::Event.new(
    summary: Faker::Company.catch_phrase,
    location: Faker::Address.full_address,
    description: Faker::Company.bs,
    start: Google::Apis::CalendarV3::EventDateTime.new(
      date_time: meeting_date + "T" + formatted_start_time_rec,
      time_zone: CONFIG['time_zone']
    ),
    end: Google::Apis::CalendarV3::EventDateTime.new(
      date_time: meeting_date + "T" + end_time_rec,
      time_zone: CONFIG['time_zone']
    ),recurrence: recurrence_pattern,
    attendees: meeting_attendees)


    result = service.insert_event('primary', event)
    puts "Event created: #{result.html_link}"
end
