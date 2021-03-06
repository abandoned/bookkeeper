class UserSessionsController < InheritedResources::Base
  layout "sign"

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:destroy]

  actions :new, :create, :destroy

  def create
    create! do |success, failure|
      success.html { redirect_back_or_default ledger_items_path }
      failure.html {
        flash.now[:error] = 'Username or password is incorrect.'
        render :action => :new
      }
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "You are logged out."
    redirect_to new_user_session_path
  end
end
