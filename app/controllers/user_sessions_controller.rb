class UserSessionsController < InheritedResources::Base
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:destroy]
  
  actions :new, :create, :destroy
  
  def create
    create! do |success, failure|
      success.html { redirect_back_or_default ledger_items_path }
      failure.html {
        flash.now[:failure] = 'Username or password is incorrect.'
        render :action => :new
      }
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to root_path
  end
end