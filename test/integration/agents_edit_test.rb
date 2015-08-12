require 'test_helper'

class AgentsEditTest < ActionDispatch::IntegrationTest
  def setup
    @agent = agents(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@agent)
    get edit_agent_path(@agent)
    assert_template 'agents/edit'
    patch agent_path(@agent), agent: { name:  "",
                                       email: "foo@invalid",
                                       password: "foo",
                                       password_confirmation: "bar" }
    assert_template 'agents/edit'
  end

  test "successful edit" do
    log_in_as(@agent)
    get edit_agent_path(@agent)
    assert_template 'agents/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch agent_path(@agent), agent: { name:  name,
                                       email: email,
                                       password:              "",
                                       password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @agent
    @agent.reload
    assert_equal @agent.name,  name
    assert_equal @agent.email, email
  end

  test "successful admin edit" do
    log_in_as(@agent)
    other_agent = agents(:lana)
    get edit_agent_path(other_agent)
    assert_template 'agents/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch agent_path(other_agent), agent: { name:  name,
                                       email: email,
                                       password:              "",
                                       password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to other_agent
    other_agent.reload
    assert_equal other_agent.name,  name
    assert_equal other_agent.email, email
  end

  test "successful edit with friendly forwarding" do
    get edit_agent_path(@agent)
    log_in_as(@agent)
    assert_redirected_to edit_agent_path(@agent) 
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch agent_path(@agent), agent: { name:  name,
                                       email: email,
                                       password: "foobar",
                                       password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @agent
    @agent.reload
    assert_equal @agent.name,  name
    assert_equal @agent.email, email
  end
end
