class UserSessionsController < InheritedResources::Base
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  actions :new, :create, :destroy
  
  def create
    create! do |success, failure|
      success.html { redirect_back_or_default root_path }
      failure.html {
        flash.now[:failure] = 'Username or password is incorrect.'
        render :action => :new
      }
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:success] = 'You are logged out.'
    redirect_to root_path
  end
end
