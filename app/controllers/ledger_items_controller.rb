class LedgerItemsController < InheritedResources::Base
  belongs_to    :account, :optional => true
  respond_to    :html
  respond_to    :csv, :only => [:index]
  defaults      :resource_class         => LedgerItem,
                :collection_name        => 'ledger_items',
                :instance_name          => 'ledger_item',
                :route_collection_name  => 'transactions', :route_instance_name => 'transaction'
  
  before_filter :require_user
  before_filter :find_cart,
                :only => [:index, :add_to_cart, :balance_cart, :save_cart]
  
  def index
    store_location
    
    # TODO Refactor below.
    if request.format.csv?
      unless params[:account].blank?
        filename = Account.find(params[:account]).name.gsub(/\s/, '').underscore
      else
        filename = 'ledger'
      end
      
      headings = ['transacted on', 'account', 'currency', 'total amount', 'tax amount', 'description', 'sender', 'recipient', 'match']
      output = FasterCSV.generate_line(headings)
      
      data = end_of_association_chain.
        scope_by(params[:query]).
        all(
          :include  => [:sender, :recipient, :match],
          :order    => 'ledger_items.transacted_on ASC')
      data.each do |ledger_item|
        if ledger_item.matched?
          if ledger_item.matches.size > 1
            match = 'Split'
          else
            match = ledger_item.matches.first.account.name
          end
        else
          match = nil
        end
        data = [
          ledger_item.transacted_on,
          ledger_item.account_name,
          ledger_item.currency,
          ledger_item.total_amount,
          ledger_item.tax_amount,
          ledger_item.description,
          ledger_item.sender_name,
          ledger_item.recipient_name,
          match
        ]
        output << FasterCSV.generate_line(data)
      end
      
      return send_data(output, :filename => "#{filename}.#{Time.now.strftime('%y%m%d%H%M%S')}.csv")
    end
    
    calculate_totals
    index!
  end
  
  def new
    @ledger_item = LedgerItem.new(:account_id => params[:account])
    @ledger_items = [@ledger_item]
    new!
  end

  def create
    @ledger_items = []

    begin
      LedgerItem.transaction do
        params[:ledger_items].each_value do |item_attributes|
          @ledger_items << LedgerItem.new(item_attributes)
        end
        @ledger_items.each do |item|
          item.save! unless item.sender_id.blank? && item.recipient_id.blank? && item.total_amount.blank?
        end
      end
      flash[:success] = 'Items successfully saved.'

      redirect_back_or_default(collection_path)
    rescue Exception => e
      flash[:failure] = 'Items failed to save.'
      
      render :action => :new
    end
  end
  
  def edit
    @ledger_item = LedgerItem.find params[:id]
    @ledger_items = [@ledger_item]
  end
  
  def add_to_cart
    ledger_item = LedgerItem.find(params[:id])
    @cart.add(ledger_item)
    
    redirect_back_or_default(collection_path)
  end
  
  def balance_cart
    account = Account.find(params[:ledger_item][:account_id])
    match = Match.new(:ledger_items => @cart.ledger_items)
    match.create_balancing_item(account)
    if match.save
      flash[:success] = 'Ledger item successfully reconciled'
      reset_cart
    else
      flash[:success] = 'Reconciliation failed'
    end
    
    redirect_back_or_default(collection_path)
  end
  
  def save_cart
    if Match.create(:ledger_items => @cart.ledger_items)
      flash[:success] = 'Ledger items successfully reconciled'
      reset_cart
    else
      flash.now[:failure] = 'Reconciliation failed'
    end
    
    redirect_back_or_default(collection_path)
  end
  
  def empty_cart
    reset_cart
    
    redirect_back_or_default(collection_path)
  end
  
  private
  
  def collection
    end_of_association_chain.
      scope_by(params[:query]).
      paginate(
      :page => params[:page],
      :include => [:sender, :recipient],
      :order => 'ledger_items.transacted_on ASC')
  end
  
  def find_cart
    @cart ||= session[:cart] ||= Cart.new
  end
  
  def reset_cart
    @cart = session[:cart] = Cart.new
  end
  
  # Iterates over ledger items in the collection, summing up the totals
  # for each currency
  def calculate_totals
    @totals = {}
    end_of_association_chain.
      scope_by(params[:query]).
      sum(:total_amount, :group => :currency).
      each_pair do |currency, total_amount|
        @totals[LedgerItem::CURRENCY_SYMBOLS[currency]] = total_amount.round(2)
      end
  end
end
