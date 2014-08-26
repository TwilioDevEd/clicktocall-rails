class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # Need to comment out for Twilio to be able to POST to our routes.
  # protect_from_forgery with: :exception
end
