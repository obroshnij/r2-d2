class InternalAccountsController < ApplicationController

  before_action :authenticate_user!
  authorize_resource

  def index
    @internal_accounts = InternalAccount.all
  end

  def new
    @internal_account = InternalAccount.new
  end

  def create
    @internal_account = InternalAccount.new(internal_account_params)
    if @internal_account.save
      flash[:notice] = "The record has been added"
      redirect_to action: :index
    else
      flash.now[:alert] = @internal_account.errors.full_messages.join("; ")
      render action: :new
    end
  end

  def destroy
    @internal_account = InternalAccount.find(params[:id])
    flash[:notice] = "The record has been deleted" if @internal_account.destroy
    redirect_to action: :index
  end

  private

  def internal_account_params
    params.require(:internal_account).permit(:username, :comment)
  end

end