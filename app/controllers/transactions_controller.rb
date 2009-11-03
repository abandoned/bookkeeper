class TransactionsController < InheritedResources::Base
  before_filter :require_user
  before_filter :find_cart, :only => [:index, :add_to_cart, :save_cart]
  after_filter :match, :only => [:create, :update]
  belongs_to :account, :optional => true
  respond_to :html, :xml
  has_scope :account,   :only => :index
  has_scope :person,    :only => :index
  has_scope :query,     :only => :index
  has_scope :unmatched, :only => :index
  #has_scope :from,     :only => :index
  #has_scope :to,       :only => :index
  
  def index
    @totals = {}
    end_of_association_chain.all.each do |t|
      @totals[t.currency_symbol] ||= 0.0
      @totals[t.currency_symbol] += t.total_amount.round(2)
    end
    index!
  end
  
  def save_cart
    if @cart.balance == 0
      match = Match.create! :transactions => @cart.transactions
      @cart = Cart.new
      flash[:notice] = "Transactions successfully reconciled"
    else
      flash[:error] = "Could not reconcile transactions"
    end
    respond_to do |format|  
      format.html { redirect_to :action => :index }
    end
  end
    
  protected
  
  def collection
    @transactions ||= end_of_association_chain.paginate(
      :page => params[:page],
      :order => "transactions.issued_on ASC")
  end
    
  def match
    resource.account.rules.each do |m|
      break if m.match(resource)
    end
  end
  
  private
  
  def find_cart
    session[:cart] ||= Cart.new
    @cart = session[:cart]
  end
end
