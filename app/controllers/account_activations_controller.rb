class AccountActivationsController < ApplicationController

  def edit
    agent = Agent.find_by(email: params[:email])
    if agent && !agent.activated? && agent.authenticated?(:activation, params[:id])
      agent.activate
      log_in agent
      flash[:success] = "Account activated!"
      redirect_to agent
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
