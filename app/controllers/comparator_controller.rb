class ComparatorController < ApplicationController

  def new
  end

  def create
    list_one, list_two = params[:list_one].downcase.split, params[:list_two].downcase.split
    result = []
    list_one.each do |domain|
      result << domain unless list_two.include?(domain)
    end
    @result = result.inject("") { |res, domain| res + "#{domain}\n" }.chomp
    @list_one = list_one.inject("") { |res, domain| res + "#{domain}\n" }.chomp
    @list_two = list_two.inject("") { |res, domain| res + "#{domain}\n" }.chomp

    render 'new'
  end

end
