require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  def setup
    @agent = agents(:michael)
    @other_agent = agents(:archer)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | #{ENV['app_title']}"
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @agent
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @agent, agent: { name: @agent.name, email: @agent.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong agent" do
    log_in_as(@other_agent)
    get :edit, id: @agent
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong agent" do
    log_in_as(@other_agent)
    patch :update, id: @agent, agent: { name: @agent.name, email: @agent.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_agent)
    assert_not @other_agent.admin?
    patch :update, id: @other_agent, agent: { password: 'somejunk',
                                            password_confirmation: 'somejunk',
                                            admin: true }
    assert_not @other_agent.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Agent.count' do
      delete :destroy, id: @agent
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_agent)
    assert_no_difference 'Agent.count' do
      delete :destroy, id: @agent
    end
    assert_redirected_to root_url
  end
end
