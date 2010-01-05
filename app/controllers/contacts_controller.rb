class ContactsController < InheritedResources::Base
  before_filter :require_user
  
  respond_to :html, :xml
  
  # http://joshuaclayton.github.com/code/2009/06/02/getting-explicit-with-before-destroy.html
  def destroy
    begin
      destroy!
    rescue ActiveRecord::RecordNotDestroyed
      flash.now[:failure] = "Cannot delete contact because she has dependants"
      render(:action => :show)
    end
  end
  
  private
  
  def collection
    @contacts ||= end_of_association_chain.paginate(
      :page => params[:page],
      :order => 'name')
  end
end
