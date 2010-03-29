class AccountsController < InheritedResources::Base
  before_filter :require_user
  
  def destroy
    # Do not delete root accounts through public interface
    if resource.is_root?
      flash.now[:failure] = "Cannot delete root account"
      return render(:action => :show)
    end
    
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
end
