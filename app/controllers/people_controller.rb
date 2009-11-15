class PeopleController < InheritedResources::Base
  before_filter :require_user
  respond_to :html, :xml
  
  # http://joshuaclayton.github.com/code/2009/06/02/getting-explicit-with-before-destroy.html
  def destroy
    begin
      destroy!
    rescue ActiveRecord::RecordNotDestroyed
      flash.now[:error] = "Cannot delete person because she has dependants"
      render(:action => :show)
    end
  end
end
