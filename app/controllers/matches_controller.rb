class MatchesController < InheritedResources::Base
  before_filter :require_user
  
  actions :show, :destroy
  
  def destroy
    destroy!{ ledger_items_path }
  end
end