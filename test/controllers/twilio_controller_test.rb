require 'test_helper'

class TwilioControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :ok
  end

  test "should fail as fake Twilio request" do
    post(:connect, {'from' => "15008675309", 'to' => '12066505813'}, {'fake-signature' => "HpS7PBa1Agvt4OtO+wZp75IuQa0="})
    assert_response 401 #Unauthorized
  end

end
