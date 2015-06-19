require 'test_helper'

class AgentMailerTest < ActionMailer::TestCase

  test "account_activation" do
    agent = agents(:michael)
    agent.activation_token = Agent.new_token
    mail = AgentMailer.account_activation(agent)
    assert_equal "Account activation", mail.subject
    assert_equal [agent.email], mail.to
    assert_equal [ENV["default_from"]], mail.from
    assert_match agent.name,               mail.body.encoded
    assert_match agent.activation_token,   mail.body.encoded
    assert_match CGI::escape(agent.email), mail.body.encoded
  end

  test "password_reset" do
    agent = agents(:michael)
    agent.reset_token = Agent.new_token
    mail = AgentMailer.password_reset(agent)
    assert_equal "Password reset", mail.subject
    assert_equal [agent.email], mail.to
    assert_equal [ENV["default_from"]], mail.from
    assert_match agent.reset_token,        mail.body.encoded
    assert_match CGI::escape(agent.email), mail.body.encoded
  end

end
