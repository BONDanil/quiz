require "test_helper"

class QuizSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get quiz_sessions_index_url
    assert_response :success
  end
end
