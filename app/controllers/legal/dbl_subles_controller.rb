class Legal::DblSublesController < ApplicationController
  respond_to :json

  def create
    entities = DblSublChecker.new params[:query]
    @domains = entities.domains
    @records = entities.records
  end
end
