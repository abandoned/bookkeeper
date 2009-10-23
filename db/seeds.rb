# Default user
User.create!([{
  :login => "bookkeeper",
  :email => "bookkeeper@example.com",
  :password => "secret",
  :password_confirmation => "secret" }])

# Set up root accounts in ledger
%w{Assets Liabilities Equity Revenue Expenses}.each do |name|
  LedgerAccount.create!(:name => name)
end

# Set up some basic accounts
{"Assets"             => ["Current Assets", "Fixed Assets", "Other Assets"],
"Liabilities"         => ["Current Liabilities", "Long Term Liabilities"],
"Revenue"             => ["Sales", "Other Miscellaneous Income"],
"Expenses"            => [
  "Bank Charges",
  "Cost of Goods Sold",
  "Dues and Subscriptions",
  "Insurance",
  "Legal and Professional Fees",
  "Meals and Entertainment",
  "Office Expenses",
  "Other Miscellaneous Expenses",
  "Rent or Lease",
  "Repair and Maintenance",
  "Supplies",
  "Taxes and Licenses",
  "Travel",
  "Utilities"]}.
  each_pair do |parent_name, children|
  parent = LedgerAccount.find_by_name(parent_name)
  children.each{ |name| LedgerAccount.create(
    :name => name,
    :parent => parent) }
end
{"Current Assets"     => ["Bank Accounts", "Accounts Receivable"],
"Current Liabilities" => ["Credit Cards", "Accounts Payable"]}.
  each_pair do |parent_name, children|
  parent = LedgerAccount.find_by_name(parent_name)
  children.each{ |name| LedgerAccount.create(
    :name => name,
    :parent => parent) }
end