require 'test_helper'

class TwilioControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :ok
  end

  test "should fail as fake Twilio request" do
    @request.env['HTTP_X_TWILIO_SIGNATURE'] = "FAKE_SIGNATURE"
    post :connect, 'from' => '15008675309', 'to' => '12066505813'
    assert_response 401 #Unauthorized
  end

  test "should succeed with real Twilio request" do
    # Mock the validator so that we don't have to use a real signature here.
    validator = Minitest::Mock.new
    validator.expect(:validate, true, [String, Hash, String])
    Twilio::Util::RequestValidator.stub(:new, validator) do
      @request.env['HTTP_X_TWILIO_SIGNATURE'] = "REAL_SIGNATURE"
      post :connect, 'from' => '15008675309', 'to' => '12066505813'

      assert_response :ok
      assert response.body.match(/<Say voice="alice">/)
    end
    validator.verify
  end

end
