ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # Returns true if a test agent is logged in.
  def is_logged_in?
    !session[:agent_id].nil?
  end

  # Logs in a test agent.
  def log_in_as(agent, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email: agent.email,
                                  password: password,
                                  remember_me: remember_me }
    else
      session[:agent_id] = agent.id
    end
  end

  # Log out the current agent.
  def log_out
    if integration_test?
      delete logout_path
    else
      session.delete(:agent_id)
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
