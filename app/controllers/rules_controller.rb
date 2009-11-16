class RulesController < InheritedResources::Base
  before_filter :require_user
  belongs_to :account
  respond_to :html
  
  def new
    if params[:ledger_item_id]
      ledger_item = LedgerItem.find(params[:ledger_item_id])
      @account = ledger_item.account
      @rule = Rule.new
      @rule.sender, @rule.recipient = ledger_item.recipient, ledger_item.sender
      @rule.account = ledger_item.account
      @rule.regexp = ledger_item.description
      @rule.debit = ledger_item.total_amount > 0
    else
      @account = Account.find(params[:id])
    end
    
    new!
  end
end
