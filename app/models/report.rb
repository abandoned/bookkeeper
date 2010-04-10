class Report
  TYPES = ["income_statement", "balance_sheet"]
  
  def self.income_statement
    RevenueOrExpense.roots
  end
  
  def self.balance_sheet
    AssetOrLiability.roots
  end
end