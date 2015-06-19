require 'test_helper'

class AgentTest < ActiveSupport::TestCase

  def setup
    @agent = Agent.new(name: "Example Agent", email: "agent@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @agent.valid?
  end

  test "name should be present" do
    @agent.name = "        ";
    assert_not @agent.valid?
  end

  test "email should be present" do
    @agent.email = "        ";
    assert_not @agent.valid?
  end

  test "name should not be too long" do
    @agent.name = "a" * 51
    assert_not @agent.valid?
  end

  test "email should not be too long" do
    @agent.email = "a" * 244 + "@example.com"
    assert_not @agent.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[agent@example.com USER@foo.COM A_US-ER@foo.bar.org
                               first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @agent.email = valid_address
      assert @agent.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[agent@example,com agent_at_foo.org agent.name@example.
                                   foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @agent.email = invalid_address
      assert_not @agent.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_agent = @agent.dup
    duplicate_agent.email = @agent.email.upcase
    @agent.save
    assert_not duplicate_agent.valid?
  end

  test "password should have a minimum length" do
    @agent.password = @agent.password_confirmation = "a" * 5
    assert_not @agent.valid?
  end

  test "authenticated? should return false for a agent with nil digest" do
    assert_not @agent.authenticated?(:remember, '')
  end
end
