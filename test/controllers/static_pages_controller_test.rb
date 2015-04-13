require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "#{ENV['app_title']}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{ENV['app_title']}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{ENV['app_title']}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{ENV['app_title']}"
  end

  test "should get apps" do
    get :apps
    assert_response :success
    assert_select "title", "Apps | #{ENV['app_title']}"
  end
end
