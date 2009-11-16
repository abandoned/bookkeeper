class ReportsController < ApplicationController
  def index
  end
  
  def show
    @type = params[:id]
  end
end
