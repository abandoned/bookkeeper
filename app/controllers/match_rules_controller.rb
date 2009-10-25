class MatchRulesController < InheritedResources::Base
  before_filter :require_user
  belongs_to :ledger_account
  respond_to :html
end
