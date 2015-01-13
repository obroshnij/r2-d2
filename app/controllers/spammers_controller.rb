class SpammersController < ApplicationController

  before_action :authenticate_user!
  authorize_resource

  def index
    @spammers = Spammer.all
  end

  def new
    @spammer = Spammer.new
  end

  def create
    @spammer = Spammer.new(spammer_params)
    if @spammer.save
      flash[:notice] = "The record has been added"
      redirect_to action: :index
    else
      flash.now[:alert] = @spammer.errors.full_messages.join("; ")
      render action: :new
    end
  end

  def destroy
    @spammer = Spammer.find(params[:id])
    flash[:notice] = "The record has been deleted" if @spammer.destroy
    redirect_to action: :index
  end

  private

  def spammer_params
    params.require(:spammer).permit(:username, :comment)
  end

end