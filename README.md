<a href="https://www.twilio.com">
  <img src="https://static0.twilio.com/marketing/bundles/marketing/img/logos/wordmark-red.svg" alt="Twilio" width="250" />
</a>

# Click to Call Rails

[![Build Status](https://travis-ci.org/TwilioDevEd/clicktocall-rails.svg?branch=master)](https://travis-ci.org/TwilioDevEd/clicktocall-rails)

> We are currently in the process of updating this sample template. If you are encountering any issues with the sample, please open an issue at [github.com/twilio-labs/code-exchange/issues](https://github.com/twilio-labs/code-exchange/issues) and we'll try to help you.

Click-to-call enables your company to convert web traffic into phone calls with
the click of a button. Learn how to implement it in minutes.

[Read the full tutorial here!](https://www.twilio.com/docs/tutorials/walkthrough/click-to-call/ruby/rails)

## Local development

This project is built using [Ruby on Rails](http://rubyonrails.org/) Framework.

1. First clone this repository and `cd` into it.

   ```bash
   $ git clone git://github.com/TwilioDevEd/clicktocall-rails.git
   $ cd clicktocall-rails
   ```

1. Install the dependencies.

   ```bash
   $ bundle install
   ```
Are you using a bash shell? Use echo $SHELL to find out. For a bash shell edit the ~/.bashrc or ~/.bashprofile file and add:

## Configuration

1. Copy the `.env.example` file to `.env`, and edit it including your credentials
   for the Twilio API (found at https://www.twilio.com/console/account/settings). You
   will also need a [Twilio Number](https://www.twilio.com/console/phone-numbers/incoming).

   Run `source .env` to export the environment variables.

1. Expose your application to the wider internet using ngrok. You can click
   [here](https://www.twilio.com/blog/2015/09/6-awesome-reasons-to-use-ngrok-when-testing-webhooks.html)
   for more details. This step is important because the application won't
   work as expected if you run it through localhost.

   ```bash
   $ ngrok http 3000
   ```

1. Start the development server:

   ```
   $ bundle exec rails s
   ```

## How to Demo?

1. Once ngrok is running, open up your browser and go to your ngrok URL. It will
   look like this: `http://<ngrok-subdomain>.ngrok.io`.

2. Enter a number in the box provided and click “Call Sales” to initiate a call.

## Meta

* No warranty expressed or implied.  Software is as is. Diggity.
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by Twilio Developer Education.
