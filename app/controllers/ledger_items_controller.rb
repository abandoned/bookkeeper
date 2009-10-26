class LedgerItemsController < InheritedResources::Base
  before_filter :require_user
  after_filter :match, :only => [:create, :update]
  belongs_to :ledger_account
  respond_to :html, :xml
  
  protected
  
  def match
    resource.ledger_account.match_rules.each do |m|
      break if m.match(resource)
    end
  end
end
