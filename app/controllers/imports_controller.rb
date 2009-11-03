class ImportsController < ApplicationController
  before_filter :require_user
  
  def new
    @import = Import.new
  end

  def create
    @import = Import.new(params[:import])
    return render :action => 'new' unless @import.valid?
    count = @import.process
    flash[:notice] = "#{count} transactions imported"
    redirect_to transactions_path
  end
end
