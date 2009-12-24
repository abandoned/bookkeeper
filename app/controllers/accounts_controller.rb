class AccountsController < InheritedResources::Base
  before_filter :require_user
  before_filter :scrub_parent_id, :only => [:create, :update]
  
  #defaults :resource_class => Account, :collection_name => 'accounts', :instance_name => 'account'
  
  def new
    @account = Account.new
    unless params['parent_id'].nil?
      @account.parent_id = params['parent_id']
    end
    new!
  end
  
  def destroy
    begin
      destroy!
    rescue Ancestry::AncestryException
      flash.now[:failure] = 'Cannot delete account because it has descendants'
      render(:action => :show)
    rescue ActiveRecord::RecordNotDestroyed
      flash.now[:failure] = 'Cannot delete account because it has dependants'
      render(:action => :show)
    end
  end
  
  private
  
  def scrub_parent_id
    if params[:account][:parent_id] =~ /[^0-9]/
      params[:account][:parent_id] = nil
    end
  end
end
