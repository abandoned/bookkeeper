class ImportsController < InheritedResources::Base
  before_filter :require_user
  actions       :index, :new, :create

  def create
    @import = Import.new(params['import'])
    if @import.save
      @import.update_attributes(
        :file_name => params['import']['file'].original_filename
      )
      @import.parse_file
      Delayed::Job.enqueue @import
      flash[:notice] = 'Import queued'
      redirect_to collection_path
    else
      render :new
    end
  end
  
  private
  
  def collection
    @imports ||= end_of_association_chain.paginate(
      :order  => 'created_at desc',
      :page   => params[:page])
  end
end
