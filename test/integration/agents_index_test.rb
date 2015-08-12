require 'test_helper'

class AgentsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = agents(:michael)
    @agent = agents(:archer)
  end

  test "index as admin including pagination with edit and delete links and a button to add a new agent" do
    log_in_as(@admin)
    get agents_path
    assert_template 'agents/index'

    # Only an admin can add a new agent
    assert_select 'form[action=?]', new_agent_path, text: "Add a new agent", count: 1 
    assert_select 'div.pagination'
    first_page_of_agents = Agent.paginate(page: 1)
    first_page_of_agents.each do |agent|
      assert_select 'a[href=?]', agent_path(agent), text: agent.name
      unless agent == @admin
        assert_select 'a[href=?][data-method="delete"]', agent_path(agent), method: :delete, count: 1
      end
      assert_select 'a[href=?]', edit_agent_path(agent), method: :edit
    end
    assert_difference 'Agent.count', -1 do
      delete agent_path(@agent)
    end
  end

  test "index as non-admin" do
    log_in_as(@agent)
    get agents_path
    assert_template 'agents/index'

    # Only an admin can add a new agent
    assert_select 'form[action=?]', new_agent_path, text: "Add a new agent", count: 0

    assert_select 'div.pagination'

    first_page_of_agents = Agent.paginate(page: 1)
    first_page_of_agents.each do |agent|
      assert_select 'a[href=?][data-method="delete"]', agent_path(agent), count: 0
      # An agent can edit his own profile
      if agent == @agent
        # There are two edit links: one to the left of the agent link and one 
        # under the Account dropdown menu
        assert_select 'a[href=?]', edit_agent_path(agent), count: 2
      else
        assert_select 'a[href=?]', edit_agent_path(agent), count: 0
      end
    end
  end
end
