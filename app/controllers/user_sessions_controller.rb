class UserSessionsController < InheritedResources::Base
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  actions :new, :create, :destroy
  respond_to :html
  
  def create
    create! do |success, failure|
      success.html { redirect_back_or_default root_path }
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "You are logged out."
    redirect_back_or_default root_path
  end
end
