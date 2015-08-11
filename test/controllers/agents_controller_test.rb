require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  def setup
    @admin = agents(:michael)
    @agent = agents(:archer)
  end

  #
  # index
  #
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  #
  # new
  #
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | #{ENV['app_title']}"
  end

  #
  # edit
  #
  test "should redirect edit when not logged in" do
    get :edit, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong agent" do
    log_in_as(@agent)
    get :edit, id: @admin
    assert flash.empty?
    assert_redirected_to root_url
  end

  #
  # update
  #
  test "should redirect update when not logged in" do
    patch :update, id: @admin, agent: { name: @admin.name, email: @admin.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong agent" do
    log_in_as(@agent)
    patch :update, id: @admin, agent: { name: @admin.name, email: @admin.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@agent)
    assert_not @agent.admin?
    patch :update, id: @agent, agent: { password: 'somejunk',
                                            password_confirmation: 'somejunk',
                                            admin: true }
    assert_not @agent.reload.admin?
  end

  #
  # destroy
  #
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Agent.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@agent)
    assert_no_difference 'Agent.count' do
      delete :destroy, id: @admin
    end
    assert_redirected_to root_url
  end

  test "should allow admin to destroy agent" do
    log_in_as(@admin)
    assert_difference 'Agent.count', -1 do
      delete :destroy, id: @admin
    end
    assert_redirected_to agents_url
  end
end
