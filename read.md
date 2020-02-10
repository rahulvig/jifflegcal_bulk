The two scripts can bee used to create bulk data on google calendars to test gcal integration


Steps to create data-

#1 Clone repo

#2 Obtain or generate config.yaml and credentials.json for the google account (steps at the following url will help you generate the files for your user account - https://developers.google.com/calendar/quickstart/ruby )

#3 Run 'bundle install'

#4 Check config.yaml and make necessary changes for user, start_date, end_date, attendees, duration, recurrences and single instances. (Timings can be duplicated to create duplicates on same time)

#5 Run 'bundle exec ruby create_appointments.rb' to create data

#6 Run 'bundle exec ruby delete_appointments.rb' to delete future data
