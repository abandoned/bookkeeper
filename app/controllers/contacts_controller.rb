class ContactsController < InheritedResources::Base
  before_filter :require_user
  
  # http://joshuaclayton.github.com/code/2009/06/02/getting-explicit-with-before-destroy.html
  def destroy
    begin
      destroy!
    rescue ActiveRecord::RecordNotDestroyed
      flash[:failure] = 'Cannot delete contact because she has dependants.'
      redirect_to contacts_path
    end
  end
  
  private
  
  def collection
    @contacts ||= end_of_association_chain.paginate(
      :page   => params[:page],
      :order  => 'name')
  end
end
