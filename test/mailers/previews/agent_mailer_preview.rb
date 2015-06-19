# Preview all emails at http://localhost:3000/rails/mailers/agent_mailer
class AgentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/agent_mailer/account_activation
  def account_activation
    agent = Agent.first
    agent.activation_token = Agent.new_token
    AgentMailer.account_activation(agent)
  end

  # Preview this email at http://localhost:3000/rails/mailers/agent_mailer/password_reset
  def password_reset
    agent = Agent.first
    agent.reset_token = Agent.new_token
    AgentMailer.password_reset(agent)
  end

end
