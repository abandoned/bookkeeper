class ImportsController < InheritedResources::Base
  before_filter :require_user
  belongs_to    :account
  
  def new
    @import = Import.new
  end

  def create
    @import = Import.new(params[:import])
    if @import.valid_for_processing?
      @import.process

      if @import.valid_for_importing?
        count = @import.import
        flash[:success] = "#{count} ledger items imported"
        return(redirect_to ledger_items_path)
      end
    end

    flash.now[:failure] = 'Import failed'
    render(:action => 'new')
  end
  
  private
  
  def collection
    @imports ||= end_of_association_chain.paginate(
      :order  => 'created_at desc',
      :page   => params[:page])
  end
end
