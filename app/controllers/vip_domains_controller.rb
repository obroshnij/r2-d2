class VipDomainsController < ApplicationController

  before_action :authenticate_user!
  authorize_resource

  def index
    @vip_domains = VipDomain.search(params[:search_by], params[:search], params[:page], params[:per_page])
  end

  def new
    @vip_domain = VipDomain.new
  end

  def create
    @vip_domain = VipDomain.new(vip_domain_params)
    if @vip_domain.save
      flash[:notice] = "The domain has been added"
      redirect_to action: :index
    else
      flash.now[:alert] = @vip_domain.errors.full_messages.join("; ")
      render action: :new
    end
  end

  def edit
    @vip_domain = VipDomain.find(params[:id])
  end

  def update
    @vip_domain = VipDomain.find(params[:id])
    if @vip_domain.update_attributes(vip_domain_params)
      flash[:notice] = "The record has been updated"
      redirect_to action: :index
    else
      flash.now[:alert] = @vip_domain.errors.full_messages.join("; ")
      render action: :edit
    end
  end

  def destroy
    @vip_domain = VipDomain.find(params[:id])
    flash[:notice] = "The record has been deleted" if @vip_domain.destroy
    redirect_to action: :index
  end

  private

  def vip_domain_params
    params.require(:vip_domain).permit(:domain, :username, :category, :notes)
  end

end