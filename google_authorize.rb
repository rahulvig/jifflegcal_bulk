require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require 'yaml'

class GoogleAuthorize


  #code for authentication taken from https://developers.google.com/calendar/create-events

  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  CREDENTIALS_PATH = "credentials.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS


  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

end