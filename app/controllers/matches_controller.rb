class MatchesController < InheritedResources::Base
  before_filter :require_user
  
  def new
    @match = Match.new
    @match.ledger_items.build
  end
  
  def create
    flash[:error] = params['match'].inspect
    redirect_to :action => :new
  end
  
  def destroy
    destroy!{ ledger_items_path }
  end
end