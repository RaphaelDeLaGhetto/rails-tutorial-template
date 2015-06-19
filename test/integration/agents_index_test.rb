require 'test_helper'

class AgentsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = agents(:michael)
    @non_admin = agents(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get agents_path
    assert_template 'agents/index'
    assert_select 'div.pagination'
    first_page_of_agents = Agent.paginate(page: 1)
    first_page_of_agents.each do |agent|
      assert_select 'a[href=?]', agent_path(agent), text: agent.name
      unless agent == @admin
        assert_select 'a[href=?]', agent_path(agent), text: 'delete',
                                                    method: :delete
      end
    end
    assert_difference 'Agent.count', -1 do
      delete agent_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get agents_path
    assert_select 'a', text: 'delete', count: 0
  end
end
