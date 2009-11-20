class ImportsController < ApplicationController
  before_filter :require_user
  
  def new
    @import = Import.new
  end

  def create
    flash[:notice] = "import"
    return redirect_to ledger_items_path
    
    @import = Import.new(params[:import])
    if @import.valid_for_processing?
      @import.process

      if @import.valid_for_importing?
        count = @import.import
        flash[:notice] = "#{count} ledger items imported"
        return redirect_to ledger_items_path
      end
    end

    flash.now[:error] = 'Import failed'
    render(:action => 'new')
  end
end
