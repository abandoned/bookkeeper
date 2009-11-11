# Default user
User.create!([{
  :login => "bookkeeper",
  :email => "bookkeeper@example.com",
  :password => "secret",
  :password_confirmation => "secret" }])

# Set up root accounts in ledger
%w{Assets Liabilities Equity Revenue Expenses}.each do |name|
  Account.create!(:name => name)
end

# Set up basic accounts
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
  parent = Account.find_by_name(parent_name)
  children.each{ |name| Account.create(
    :name => name,
    :parent => parent) }
end
{"Current Assets"     => ["Bank Accounts", "Accounts Receivable"],
"Current Liabilities" => ["Credit Cards", "Accounts Payable"]}.
  each_pair do |parent_name, children|
  parent = Account.find_by_name(parent_name)
  children.each{ |name| Account.create(
    :name => name,
    :parent => parent) }
end

# Some more data for demo
Person.create!([
  { :name => "Paper Cavalier, Llc",
    :country => "United States",
    :is_self => true },
  { :name => "Paper Cavalier, Ltd",
    :country => "United Kingdom",
    :is_self => true },
  { :name => "Starbucks",
    :country => "United States",
    :is_self => false },
  { :name => "Costa Coffee",
    :country => "United Kingdom",
    :is_self => false }
])
{"Bank Accounts" => ["Citibank", "Barclays"]}.
  each_pair do |parent_name, children|
  parent = Account.find_by_name(parent_name)
  children.each{ |name| Account.create(
    :name => name,
    :parent => parent) }
end
Mapping.create!([
  { :name => "Citibank",
    :currency => "USD",
    :date_row => 1,
    :total_amount_row => 3,
    :description_row => 2, 
    :has_title_row => false,
    :day_follows_month => true,
    :reverses_sign => false }
])