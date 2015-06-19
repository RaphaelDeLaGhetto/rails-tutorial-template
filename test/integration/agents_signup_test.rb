require 'test_helper'

class AgentsSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'Agent.count' do
      post agents_path, agent: { name:  "",
                               email: "agent@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'agents/new'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'Agent.count', 1 do
      post agents_path, agent: { name:  "Example Agent",
                               email: "agent@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    agent = assigns(:agent)
    assert_not agent.activated?
    # Try to log in before activation.
    log_in_as(agent)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(agent.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(agent.activation_token, email: agent.email)
    assert agent.reload.activated?
    follow_redirect!
    assert_template 'agents/show'
    assert is_logged_in?
  end

#  test "display success flash message" do
#    get signup_path
#    post_via_redirect agents_path, agent: { name:  "Example Agent",
#                                          email: "agent@example.com",
#                                          password: "password",
#                                          password_confirmation: "password" }
#
#    assert_template 'agents/show' #    assert_not flash.empty?
#  end


end
