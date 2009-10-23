class LedgerItemsController < InheritedResources::Base
  before_filter :require_user
  belongs_to :ledger_account
  respond_to :html, :xml
end
