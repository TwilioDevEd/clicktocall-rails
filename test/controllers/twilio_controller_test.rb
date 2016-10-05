require 'test_helper'

class TwilioControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :ok
  end

  test 'should initiate a call with a real phone number' do
    twilio_number = '15008675309'
    to_number = '12066505813'
    client = Minitest::Mock.new
    calls = Minitest::Mock.new
    calls.expect(:create, true, [{ from: twilio_number, to: to_number, url: 'http://test.host/connect' }])
    client.expect(:calls, calls)

    ENV['TWILIO_NUMBER'] = twilio_number
    Twilio::REST::Client.stub :new, client do
      post :call, phone: to_number, format: 'json'

      assert_response :ok
      json = JSON.parse(response.body)
      assert_equal 'ok', json['status']
      assert_equal 'Phone call incoming!', json['message']
    end

    client.verify
    calls.verify
  end

  test 'should return a failure with a non real phone number' do
    post :call, phone: 'blah', format: 'json'

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 'ok', json['status']
    assert_equal ['Phone is an invalid number'], json['message']
  end

  test 'should fail as fake Twilio request' do
    @request.env['HTTP_X_TWILIO_SIGNATURE'] = 'FAKE_SIGNATURE'
    post :connect, from: '15008675309', to: '12066505813'
    assert_response 401 # Unauthorized
  end

  test 'should succeed with real Twilio request' do
    # Mock the validator so that we don't have to use a real signature here.
    validator = Minitest::Mock.new
    validator.expect(:validate, true, [String, Hash, String])
    Twilio::Security::RequestValidator.stub(:new, validator) do
      @request.env['HTTP_X_TWILIO_SIGNATURE'] = 'REAL_SIGNATURE'
      post :connect, from: '15008675309', to: '12066505813'

      assert_response :ok
      assert response.body.match(/<Say voice="alice">/)
    end

    validator.verify
  end
end
