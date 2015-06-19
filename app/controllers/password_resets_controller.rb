class PasswordResetsController < ApplicationController
  before_action :get_agent,   only: [:edit, :update]
  before_action :valid_agent, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @agent = Agent.find_by(email: params[:password_reset][:email].downcase)
    if @agent
      if @agent.activated?
        @agent.create_reset_digest
        @agent.send_password_reset_email
        flash[:info] = "Email sent with password reset instructions"
      else
        @agent.create_activation_digest
        @agent.save
        @agent.send_activation_email
        flash[:info] = "Please check your email to activate your account."
      end
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @agent.update_attributes(agent_params)
      log_in @agent
      flash[:success] = "Password has been reset."
      redirect_to @agent
    else
      render 'edit'
    end
  end

  private

    def agent_params
      params.require(:agent).permit(:password, :password_confirmation)
    end

    # Returns true if password is blank.
    def password_blank?
      params[:agent][:password].blank?
    end

    # Before filters

    def get_agent
      @agent = Agent.find_by(email: params[:email])
    end

    # Confirms a valid agent.
    def valid_agent
      unless (@agent && @agent.activated? && @agent.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @agent.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
