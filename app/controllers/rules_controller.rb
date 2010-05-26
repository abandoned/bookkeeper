class RulesController < InheritedResources::Base
  before_filter :require_user
  belongs_to    :account
  actions       :all, :except => :show
  
  def new
    if params[:ledger_item_id]
      ledger_item = LedgerItem.find(params[:ledger_item_id])
      @account = ledger_item.account
      @rule = Rule.new
      @rule.new_sender, @rule.new_recipient = ledger_item.sender, ledger_item.recipient
      @rule.account = ledger_item.account
      @rule.matched_description = ledger_item.description
      @rule.matched_debit = ledger_item.total_amount > 0
    end
    new!
  end
  
  def create
    create! { account_rules_path }
  end
  
  def update
    update! { account_rules_path }
  end

  private

  def collection
    @rules ||= end_of_association_chain.paginate(
      :page   => params[:page])
  end
end
