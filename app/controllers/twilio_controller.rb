require 'twilio-ruby'
require 'haml'

class TwilioController < ApplicationController
  include Webhookify

  before_filter :authenticate_twilio_request, :only => [
    :connect
  ]

  # Render home page, embedding the Twilio number on the page (for mobile)
  def index
    @twilio_number = ENV['TWILIO_NUMBER']
  	render 'index'
  end

  # Hande a POST from our web form and connect a call via REST API
  def call
    contact = Contact.new
    contact.phone = params[:phone]
   
    # Validate contact
    if contact.valid?

      @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      # Connect an outbound call to the number submitted
      @call = @client.account.calls.create(
        :from => ENV['TWILIO_NUMBER'],
        :to => contact.phone,
        :url => "#{root_url}connect" # Fetch instructions from this URL when the call connects
      )

      # Lets respond to the ajax call with some positive reinforcement
      @msg = { :message => 'Phone call incoming!', :status => 'ok' }

    else

      # Oops there was an error, lets return the validation errors
      @msg = { :message => contact.errors.full_messages, :status => 'ok' }
    end
    respond_to do |format|
      format.json { render :json => @msg }
    end
  end

  # // This URL contains instructions for the call that is connected with a lead
  # // that is using the web form.  These instructions are used either for a
  # // direct call to our Twilio number (the mobile use case) or 
  def connect

    # // Our response to this request will be an XML document in the "TwiML"
    # // format. Our Ruby library provides a helper for generating one
    # // of these documents
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Thanks for your interest in 5 5 5 Main Street! I will connect you to an agent now.', :voice => 'alice'
      r.Dial ENV['AGENT_NUMBER']
    end
    # Defined in webhookify.rb. Renders XML page.
    set_header
    render_twiml response
  end


  # Authenticate that all requests to our public-facing TwiML pages are
  # coming from Twilio. Adapted from the example at 
  # http://twilio-ruby.readthedocs.org/en/latest/usage/validation.html
  # Read more on Twilio Security at https://www.twilio.com/docs/security
  private
  def authenticate_twilio_request
    twilio_signature = request.headers['HTTP_X_TWILIO_SIGNATURE']

    # Helper from twilio-ruby to validate requests. 
    @validator = Twilio::Util::RequestValidator.new(ENV['TWILIO_AUTH_TOKEN'])
 
    # the POST variables attached to the request (eg "From", "To")
    # Twilio requests only accept lowercase letters. So scrub here:
    post_vars = params.reject {|k, v| k.downcase == k}
 
    is_twilio_req = @validator.validate(request.url, post_vars, twilio_signature)
 
    unless is_twilio_req
      render :xml => (Twilio::TwiML::Response.new {|r| r.Hangup}).text, :status => :unauthorized
      false
    end
  end

end