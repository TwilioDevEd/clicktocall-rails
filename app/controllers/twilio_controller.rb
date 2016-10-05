require 'twilio-ruby'

class TwilioController < ApplicationController
  # Before we allow the incoming request to connect, verify
  # that it is a Twilio request
  before_action :load_credentials, only: [:call, :connect]
  before_action :authenticate_twilio_request, only: [:connect]

  # Render home page
  def index
    render 'index'
  end

  # Handle a POST from our web form and connect a call via REST API
  def call
    contact = Contact.new
    contact.phone = params[:phone]

    # Validate contact
    if contact.valid?
      @client = Twilio::REST::Client.new @twilio_sid, @twilio_token
      # Connect an outbound call to the number submitted
      @call = @client.calls.create(
        to:   contact.phone,
        from: @twilio_number,
        url:  connect_url # Fetch instructions from this URL when the call connects
      )

      # Let's respond to the ajax call with some positive reinforcement
      @msg = { message: 'Phone call incoming!', status: 'ok' }
    else

      # Oops there was an error, lets return the validation errors
      @msg = { message: contact.errors.full_messages, status: 'ok' }
    end

    respond_to do |format|
      format.json { render json: @msg }
    end
  end

  # This URL contains instructions for the call that is connected with a lead
  # that is using the web form.
  def connect
    # Our response to this request will be an XML document in the "TwiML"
    # format. Our Ruby library provides a helper for generating one
    # of these documents
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'If this were a real click to call implementation, you would be connected to an agent at this point.', voice: 'alice'
    end

    render text: response.text
  end


  # Authenticate that all requests to our public-facing TwiML pages are
  # coming from Twilio. Adapted from the example at
  # http://twilio-ruby.readthedocs.org/en/latest/usage/validation.html
  # Read more on Twilio Security at https://www.twilio.com/docs/security
  private

  def authenticate_twilio_request
    # Helper from twilio-ruby to validate requests.
    @validator = Twilio::Security::RequestValidator.new(@twilio_token)

    # the POST variables attached to the request (eg "From", "To")
    # Twilio requests only accept lowercase letters. So scrub here:
    post_vars = params.reject {|k, v| k.downcase == k}
    twilio_signature = request.headers['HTTP_X_TWILIO_SIGNATURE']

    is_twilio_req = @validator.validate(request.url, post_vars, twilio_signature)

    unless is_twilio_req
      render xml: (Twilio::TwiML::Response.new { |r| r.Hangup }).text, status: :unauthorized
      false
    end
  end

  def load_credentials
    # Define our Twilio credentials as instance variables for later use
    @twilio_sid = ENV['TWILIO_ACCOUNT_SID']
    @twilio_token = ENV['TWILIO_AUTH_TOKEN']
    @twilio_number = ENV['TWILIO_NUMBER']
  end
end
