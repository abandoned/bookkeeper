class ImportsController < ApplicationController
  before_filter :require_user
  
  def new
    @import = Import.new
  end

  def create
    @import = Import.new(params[:import])
    if @import.valid_for_processing?
      @import.process

      if @import.valid_for_importing?
        count = @import.import
        flash[:notice] = "#{count} ledger items imported"
        redirect_to ledger_items_path
        return
      end
    end

    flash[:notice] = 'Import failed'
    render(:action => 'new')
  end
end
