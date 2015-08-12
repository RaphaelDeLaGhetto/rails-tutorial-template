class AgentsController < ApplicationController
  before_action :logged_in_agent, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_agent, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :update] do
    correct_agent @agent 
  end
  before_action :admin_agent, only: [:destroy]

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
    message = "Please check your email to activate your account."
    if admin_logged_in?
      message = "An activation email has been sent to the new agent."
    elsif agent_params[:admin]
      flash[:danger] = 'You cannot create an admin agent'
      redirect_to new_agent_path
      return
    end

    @agent = Agent.new(agent_params)
    if @agent.save
      @agent.send_activation_email
      flash[:info] = message
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
    if @agent.update_attributes(admin_logged_in? ? agent_params : agent_params.except(:admin))
      flash[:success] = "Profile updated"
      redirect_to @agent
    else
      render 'edit'
    end
  end

  #
  # destroy
  #
  def destroy
    Agent.find(params[:id]).destroy
    flash[:success] = "Agent deleted"
    redirect_to agents_url
  end

  private

    def agent_params
      params.require(:agent).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def set_agent
      @agent = Agent.find(params[:id])
    end
end
