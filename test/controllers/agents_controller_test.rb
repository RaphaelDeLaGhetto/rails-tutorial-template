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
  # show
  #
  test "should redirect show when not logged in" do
    get :show, id: @agent
    assert_redirected_to login_url
  end

  test "should show when logged in" do
    log_in_as(@agent)
    get :show, id: @agent
    assert_response :success
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
  # create
  #
  test "should not allow a non-admin to create an admin agent" do
    log_in_as(@agent)
    assert_no_difference 'Agent.count' do
      post :create, agent: { name: 'Bojack Horseman',
                             email: 'bojack@netflix.com',
                             password: 'somejunk',
                             password_confirmation: 'somejunk',
                             admin: true }
    end
    assert_redirected_to new_agent_path
    assert_equal 'You cannot create an admin agent', flash[:danger]
  end

  test "should allow an admin to create an admin agent" do
    log_in_as(@admin)
    assert_difference 'Agent.count', 1 do
      post :create, agent: { name: 'Bojack Horseman',
                             email: 'bojack@netflix.com',
                             password: 'somejunk',
                             password_confirmation: 'somejunk',
                             admin: true }
    end
    assert_redirected_to root_url
    assert_equal 'An activation email has been sent to the new agent.', flash[:info]
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

  test "should allow admin to edit agent" do
    log_in_as(@admin)
    get :edit, id: @agent
    assert_response :success
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

  test "should allow admin to update agent" do
    log_in_as(@admin)
    assert_not @agent.admin?
    patch :update, id: @agent, agent: { name: 'Bojack Horseman',
                                        email: 'bojack@netflix.com' }
    @agent.reload
    assert_equal 'Bojack Horseman', @agent.name
    assert_equal 'bojack@netflix.com', @agent.email
  end

  test "should not allow a non-admin to edit the admin attribute via the web" do
    log_in_as(@agent)
    assert_not @agent.admin?
    patch :update, id: @agent, agent: { password: 'somejunk',
                                        password_confirmation: 'somejunk',
                                        admin: true }
    assert_not @agent.reload.admin?
  end

  test "should allow an admin to edit the admin attribute via the web" do
    log_in_as(@admin)
    assert @admin.admin?
    patch :update, id: @agent, agent: { password: 'somejunk',
                                        password_confirmation: 'somejunk',
                                        admin: true }
    assert @agent.reload.admin?
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
