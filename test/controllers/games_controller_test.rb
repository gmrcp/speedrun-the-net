require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get games_create_url
    assert_response :success
  end

  test "should get update" do
    get games_update_url
    assert_response :success
  end
end
