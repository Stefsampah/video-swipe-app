require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scores_index_url
    assert_response :success
  end

  test "should get show" do
    get scores_show_url
    assert_response :success
  end
end
