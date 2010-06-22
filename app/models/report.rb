class Report
  NAMES = ["Income Statement", "Balance Sheet"]

  attr_reader :name, :perspective, :to_date, :from_date, :base_currency

  def initialize(params)
    @params = params
    set_name
    set_defaults
  end

  def available?
    roots.any? { |a| a.grand_total_for?(perspective, from_date, to_date) }
  end

  def roots
    if name == 'Income Statement'
      sort_root_accounts(RevenueOrExpense.roots + CurrencyConversion.roots)
    elsif name == 'Balance Sheet'
      sort_root_accounts(AssetOrLiability.roots)
    end
  end

  def self_select_options 
    @self_select_options ||= Contact.self.collect{ |c| [c.name, c.id.to_s] }
  end

  private

  def set_name
    if NAMES.include?(@params[:id].titleize)
      @name = @params[:id].titleize
    else
      raise "Unknown report name"
    end
  end

  def set_defaults
    if @params[:base_currency].nil?
      @perspective = self_select_options.first.last
      @base_currency = 'USD'
      @from_date = Date.ordinal(Date.today.year - 1, 1)
      @to_date = Date.ordinal(Date.today.year - 1, 365)
    else
      %w{perspective to_date from_date base_currency}.each do |var_name|
        instance_variable_set("@#{var_name}".to_sym, @params[var_name.to_sym])
      end
    end

    # A balance sheet covers all ledger items from the beginning of (the) history
    # of the company to the date requested
    @from_date = "1990-01-01" if name == "Balance Sheet"
  end

  def sort_root_accounts(collection)
    collection.sort { |x, y|
      y.grand_total_for_in_base_currency(perspective, from_date, to_date, base_currency) <=> 
      x.grand_total_for_in_base_currency(perspective, from_date, to_date, base_currency) }
  end
end
