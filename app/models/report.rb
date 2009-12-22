class Report
  TYPES = ["income_statement", "balance_sheet"]
  
  def self.income_statement
    collect_accounts(4..5)
  end
  
  def self.balance_sheet
    collect_accounts(1..3)
  end
  
  private
  
  def self.collect_accounts(range)
    range.collect { |i|  Account.find(i) }    
  end
end