require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, ENV['app_title'] 
    assert_equal full_title("Help"), "Help | #{ENV['app_title']}"
  end
end
