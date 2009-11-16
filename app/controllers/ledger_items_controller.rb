class LedgerItemsController < InheritedResources::Base
  belongs_to    :account, :optional => true
  respond_to    :html
  has_scope     :account, :only => :index
  has_scope     :person, :only => :index
  has_scope     :query, :only => :index
  has_scope     :unmatched, :only => :index
  has_scope     :from_date, :only => :index
  has_scope     :to_date, :only => :index
  before_filter :require_user
  before_filter :find_cart, :only => [:index, :add_to_cart, :balance_cart, :save_cart]
  after_filter  :match_by_rules, :only => [:create, :update]
  
  def index
    @ledger_item = LedgerItem.new
    calculate_totals
    index!
  end
  
  def new
    @ledger_item = LedgerItem.new(:account_id => params[:account_id])
    resource.transacted_on ||= Date.today
    new!
  end
  
  def add_to_cart
    ledger_item = LedgerItem.find(params[:id])
    @cart.add(ledger_item)
    redirect_to collection_path
  end
  
  def balance_cart
    account = Account.find(params[:ledger_item][:account_id])
    match = Match.new(:ledger_items => @cart.ledger_items)
    match.create_balancing_item(account)
    if match.save
      flash[:notice] = 'Ledger item successfully reconciled'
      reset_cart
    else
      flash[:notice] = 'Reconciliation failed'
    end
    
    redirect_to collection_path
  end
  
  def save_cart
    if Match.create(:ledger_items => @cart.ledger_items)
      flash[:notice] = "Ledger items successfully reconciled"
      reset_cart
    else
      flash.now[:error] = 'Reconciliation failed'
    end
    
    redirect_to collection_path
  end
  
  protected
  
  def find_cart
    @cart ||= session[:cart] ||= Cart.new
  end
  
  def reset_cart
    @cart = session[:cart] = Cart.new
  end
  
  def collection
    @ledger_items ||= end_of_association_chain.paginate(
      :page => params[:page],
      :order => "ledger_items.transacted_on ASC")
  end
  
  # Iterates over ledger items in the collection, summing up the totals
  # for each currency
  def calculate_totals
    @totals = {}
    end_of_association_chain.all.each do |t|
      @totals[t.currency_symbol] = @totals[t.currency_symbol] || 0.0
      @totals[t.currency_symbol] += t.total_amount.round(2)
    end
  end
  
  # Tries to match ledger item by running existing rules
  def match_by_rules
    resource.account.rules.each do |rule|
      break if rule.match(resource)
    end
  end
end
