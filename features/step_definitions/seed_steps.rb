Given /^I have a default ledger set up$/ do
  steps %Q{
    Given an account: "Assets" exists with name: "Assets"
    And an account: "Liabilities" exists with name: "Liabilities"
    And an account: "Equity" exists with name: "Equity"
    And an account: "Revenue" exists with name: "Revenue"
    And an account: "Expenses" exists with name: "Expenses"
  }
end

Given /^I have accounts set up for purchasing beverages$/ do
  steps %Q{
    Given an account "Bank Account" exists with name: "Bank Account", parent: account "Assets"
    And an account "Beverages" exists with name: "Beverages", parent: account "Expenses"
  }
end

Given /^I have contacts set up for purchasing beverages$/ do
  steps %Q{
    Given a contact "Self" exists with name: "Self"
    And a contact "Coffee Vendor" exists with name: "Coffee Vendor"
  }
end

Given /^I have bought some beverages$/ do
  steps %Q{
    Given I have accounts set up for purchasing beverages
    And a ledger_item "Coffee" exists with description: "Coffee", total_amount: 3.00, currency: "USD", account: account "Beverages", transacted_on: "2009/01/01"
    And a ledger_item "Hot Chocolate" exists with description: "Hot Chocolate", total_amount: 2.00, currency: "USD", account: account "Beverages", transacted_on: "2009/01/02"
    And a ledger_item "Tea" exists with description: "Tea", total_amount: 1.50, currency: "USD", account: account "Beverages", transacted_on: "2009/01/03"
    And a ledger_item "Coffee Purchased" exists with description: "Purchase", identifier: "XXXX1", total_amount: -3.00, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/01"
    And a ledger_item "Hot Chocolate Purchased" exists with description: "Purchase", identifier: "XXXX2", total_amount: -2.00, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/02"
    And a ledger_item "Tea Purchased" exists with description: "Purchase", identifier: "XXXX3", total_amount: -1.50, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/03"
  }
end

Given /^I have a double entry for a beverage purchase$/ do
  steps %Q{
    Given I have accounts set up for purchasing beverages
    And I have contacts set up for purchasing beverages
    And a match exists
    And a ledger_item "Coffee" exists with description: "Coffee", total_amount: 3.00, currency: "USD", account: account "Beverages", transacted_on: "2009/01/01", sender: contact "Coffee Vendor", recipient: contact "Self", match: the match
    And a ledger_item "Purchase" exists with description: "Purchase", total_amount: -3.00, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/01", sender: contact "Self", recipient: contact "Coffee Vendor", match: the match
  }
end