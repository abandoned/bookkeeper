class Report
  TYPES = ["income_statement", "balance_sheet"]
  
  def self.income_statement
    Revenue.roots + Expense.roots
  end
  
  def self.balance_sheet
    Asset.roots + Liability.roots + Equity.roots
  end
end