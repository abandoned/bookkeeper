class AccountsController < InheritedResources::Base
  before_filter :require_user
  before_filter :clean_parent_id, :only => [:create, :update]
  respond_to :html
  
  def new
    @account = Account.new
    unless params["parent_id"].nil?
      @account.parent_id = params["parent_id"]
    end
    new!
  end
  
  def destroy
    begin
      destroy!
    rescue Ancestry::AncestryException
      flash.now[:error] = "Cannot delete account because it has descendants"
      render(:action => :show)
    rescue ActiveRecord::RecordNotDestroyed
      flash.now[:error] = "Cannot delete account because it has dependants"
      render(:action => :show)
    end
  end
  
  protected
  
  def clean_parent_id
    if params[:account][:parent_id] =~ /[^0-9]/
      params[:account][:parent_id] = nil
    end
  end
end
