module SessionsHelper

  # Logs in the given agent.
  def log_in(agent)
    session[:agent_id] = agent.id
  end

  # Remembers a agent in a persistent session.
  def remember(agent)
    agent.remember
    cookies.permanent.signed[:agent_id] = agent.id
    cookies.permanent[:remember_token] = agent.remember_token
  end

  # Returns true if the given agent is the current agent.
  def current_agent?(agent)
    agent == current_agent
  end

  # Returns the current logged-in agent (if any).
  def current_agent
    if (agent_id = session[:agent_id])
      @current_agent ||= Agent.find_by(id: agent_id)
    elsif (agent_id = cookies.signed[:agent_id])
      agent = Agent.find_by(id: agent_id)
      if agent && agent.authenticated?(:remember, cookies[:remember_token])
        log_in agent
        @current_agent = agent
      end
    end
  end

  # Returns true if the agent is logged in, false otherwise.
  def logged_in?
    !current_agent.nil?
  end

  # Confirms the correct agent.
  def correct_agent(agent)
    if !admin_logged_in?
      redirect_to(root_url) unless current_agent?(agent)
    end
  end

  # Returns true if the agent is logged in as an admin, false otherwise.
  def admin_logged_in?
    !current_agent.nil? && current_agent.admin?
  end

  # Forgets a persistent session.
  def forget(agent)
    agent.forget
    cookies.delete(:agent_id)
    cookies.delete(:remember_token)
  end

  # Log out the current agent.
  def log_out
    forget(current_agent);
    session.delete(:agent_id)
    @current_agent = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Confirms an admin agent.
  def admin_agent
    redirect_to(root_url) unless current_agent && current_agent.admin?
  end

  # Confirms a logged-in agent.
  def logged_in_agent
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
