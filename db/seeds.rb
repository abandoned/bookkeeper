def seed_accounts(hash)
  hash.each_pair do |parent_name, children|
    parent = Account.find_by_name(parent_name)
    children.each{ |name| parent.class.create(
      :name => name,
      :parent => parent) }
  end
end

# Set up default user
User.create!([{
  :login => 'bookkeeper',
  :email => 'user@example.com',
  :password => 'secret',
  :password_confirmation => 'secret' }])

# Set up root accounts in ledger
%w{Assets Liabilities Equity}.each do |name|
  AssetOrLiability.create!(:name => name)
end
['Revenue', 'Expenses', 'Cost of Goods Sold'].each do |name|
  RevenueOrExpense.create!(:name => name)
end
CurrencyConversion.create!(:name => 'Currency Conversion')

# Set up some basic accounts
seed_accounts({
  'Assets'      => ['Current Assets', 'Fixed Assets', 'Other Assets'],
  'Liabilities' => ['Current Liabilities', 'Long Term Liabilities'],
  'Revenue'     => ['Sales', 'Other Miscellaneous Income'],
  'Expenses'    => [
                    'Bank Charges',
                    'Dues and Subscriptions',
                    'Insurance',
                    'Legal and Professional Fees',
                    'Meals and Entertainment',
                    'Office Expenses',
                    'Other Miscellaneous Expenses',
                    'Rent or Lease',
                    'Repair and Maintenance',
                    'Supplies',
                    'Taxes and Licenses',
                    'Travel',
                    'Utilities'
                  ]})
seed_accounts({
  'Current Assets'      => ['Bank Accounts', 'Accounts Receivable'],
  'Current Liabilities' => ['Credit Cards', 'Accounts Payable']
})