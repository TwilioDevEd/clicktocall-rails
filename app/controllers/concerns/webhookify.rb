# Written by Carter Rabasa - @CarterRabasa to easily render TwiML enpoints.
module Webhookify
	extend ActiveSupport::Concern

	def set_header
      response.headers["Content-Type"] = "text/xml"
	end

	def render_twiml(response)
      render text: response.text
	end

end