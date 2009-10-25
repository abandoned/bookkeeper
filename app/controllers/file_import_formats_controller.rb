class FileImportRulesController < InheritedResources::Base
  before_filter :require_user
  belongs_to :ledger_account, :singleton => true
  respond_to :html
end
