class Legal::LinkDisablersController < ApplicationController
  respond_to :json

  def create
    @disabled_links = Legal::LinkDisabler.new(link_disabler_params[:links], link_disabler_params[:mode])
    respond_with @disabled_links
  end

  def link_disabler_params
    params.require(:link_disabler).permit(:links, :mode)
  end

end