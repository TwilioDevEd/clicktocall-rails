require 'twilio-ruby'

class TwilioControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :ok
  end

  test "should successfully call from Twilio" do 
    @client = Twilio::REST::Client.new ENV['TWILIO_TEST_ACCOUNT_SID'], ENV['TWILIO_TEST_AUTH_TOKEN']
    call = @client.account.calls.create(
      :url => "http://demo.twilio.com/docs/voice.xml",
      :to => "+12066505813",
      :from => "+15005550006"
    )
    assert_response :ok
  end

  test "should fail as fake Twilio request" do
    post(:connect, {'from' => "15008675309", 'to' => '12066505813'}, {'fake-signature' => "HpS7PBa1Agvt4OtO+wZp75IuQa0="})
    assert_response 401 #Unauthorized
  end

end