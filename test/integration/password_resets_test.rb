require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @agent = agents(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @agent.email }
    assert_not_equal @agent.reset_digest, @agent.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    agent = assigns(:agent)
    # Wrong email
    get edit_password_reset_path(agent.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive agent
    agent.toggle!(:activated)
    get edit_password_reset_path(agent.reset_token, email: agent.email)
    assert_redirected_to root_url
    agent.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: agent.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(agent.reset_token, email: agent.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", agent.email
    # Invalid password & confirmation
    patch password_reset_path(agent.reset_token),
          email: agent.email,
          agent: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Blank password
    patch password_reset_path(agent.reset_token),
          email: agent.email,
          agent: { password:              "  ",
          password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch password_reset_path(agent.reset_token),
          email: agent.email,
          agent: { password:              "foobaz",
          password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to agent
  end

  test "password reset on inactive agent" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Valid email, inactive agent
    assert_nil @agent.activation_token
    assert_nil @agent.activation_digest
    @agent.toggle!(:activated)
    post password_resets_path, password_reset: { email: @agent.email }
    assert_equal flash[:info], 'Please check your email to activate your account.'
    @agent.reload
    assert_not_nil @agent.activation_digest
    assert_redirected_to root_url
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @agent.email }

    @agent = assigns(:agent)
    @agent.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@agent.reset_token),
          email: @agent.email,
          agent: { password:              "foobar",
          password_confirmation: "foobar" }
    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired/i, response.body
  end

end

