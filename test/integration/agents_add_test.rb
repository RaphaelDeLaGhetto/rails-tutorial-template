require 'test_helper'

class AgentsAddTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @admin = agents(:michael)
    @agent = agents(:archer)
  end

  test "invalid signup information" do
    log_in_as @admin
    get new_agent_path
    assert_select "#agent_admin", count: 1
    assert_no_difference 'Agent.count' do
      post agents_path, agent: { name:  "",
                                 email: "agent@invalid",
                                 password: "foo",
                                 password_confirmation: "bar" }
    end
    assert_template 'agents/new'
  end

  test "invalid admin signup" do
    log_in_as @agent
    get signup_path
    assert_select "#agent_admin", count: 0
    assert_no_difference 'Agent.count' do
      post agents_path, agent: { name:  "Example Agent",
                                 email: "agent@example.com",
                                 password: "password",
                                 password_confirmation: "password",
                                 admin: true }
    end
    assert_redirected_to new_agent_path
    assert_equal 'You cannot create an admin agent', flash[:danger]
  end


  test "valid signup information with account activation" do
    log_in_as @admin
    get new_agent_path
    assert_select "#agent_admin", count: 1
    assert_difference 'Agent.count', 1 do
      post agents_path, agent: { name:  "Example Agent",
                                 email: "agent@example.com",
                                 password: "password",
                                 password_confirmation: "password",
                                 admin: false }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    agent = assigns(:agent)
    assert_not agent.activated?

    # admin was signed in
    log_out

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

  test "valid admin signup information with account activation" do
    log_in_as @admin
    get new_agent_path
    assert_select "#agent_admin", count: 1
    assert_difference 'Agent.count', 1 do
      post agents_path, agent: { name:  "Example Agent",
                                 email: "agent@example.com",
                                 password: "password",
                                 password_confirmation: "password",
                                 admin: true }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    agent = assigns(:agent)
    assert_not agent.activated?

    # admin was signed in
    log_out

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
end
