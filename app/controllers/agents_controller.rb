class AgentsController < ApplicationController
  before_action :logged_in_agent, only: [:index, :edit, :update, :destroy]
  before_action :correct_agent, only: [:edit, :update]
  before_action :admin_agent, only: :destroy

  #
  # index
  #
  def index
    @agents = Agent.paginate(page: params[:page])
  end

  #
  # show
  #
  def show
    @agent = Agent.find(params[:id])
  end

  #
  # new
  #
  def new
    @agent = Agent.new
  end

  #
  # create
  #
  def create
    @agent = Agent.new(agent_params)
    if @agent.save
      @agent.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  #
  # edit
  #
  def edit
  end

  #
  # update
  #
  def update
    if @agent.update_attributes(agent_params)
      flash[:success] = "Profile updated"
      redirect_to @agent
    else
      render 'edit'
    end
  end

  def destroy
    Agent.find(params[:id]).destroy
    flash[:success] = "Agent deleted"
    redirect_to agents_url
  end

  private

    def agent_params
      params.require(:agent).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in agent.
    def logged_in_agent
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct agent.
    def correct_agent
      @agent = Agent.find(params[:id])
      redirect_to(root_url) unless current_agent?(@agent)
    end

    # Confirms an admin agent.
    def admin_agent
      redirect_to(root_url) unless current_agent.admin?
    end
end
