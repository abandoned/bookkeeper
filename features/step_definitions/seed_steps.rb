Given /^I have a default ledger set up$/ do
  steps %Q{
    Given an account: "Assets" exists with name: "Assets", type: "Asset"
    And an account "Liabilities" exists with name: "Liabilities", type: "Liability"
    And an account "Equity" exists with name: "Equity", type: "Equity"
    And an account "Revenue" exists with name: "Revenue", type: "Revenue"
    And an account "Expenses" exists with name: "Expenses", type: "Expense"
  }
end

Given /^I am Awesome Bakery and Flour Corp is my supplier$/ do
  steps %Q{
    Given I have a default ledger set up
    And a contact "Awesome Bakery" exists with name: "Awesome Bakery", self: true
    And a contact "Flour Corp" exists with name: "Flour Corp"
    And an account "Bank Account" exists with name: "Bank Account", parent: account "Assets"
    And an account "Flour" exists with name: "Flour", parent: account "Expenses"
  }
end

Given /^I have bought some flour and have paid a utility bill$/ do
  steps %Q{
    Given an account "Utility" exists with name: "Utility", parent: account "Expenses"
    And a contact "Utility Co" exists with name: "Utility Co"
    And a ledger_item "Transaction 1" exists with total_amount: 300, account: account "Flour", transacted_on: "2008/01/01", sender: contact "Flour Corp", recipient: contact "Awesome Bakery"
    And a ledger_item "Transaction 2" exists with total_amount: 200, account: account "Flour", transacted_on: "2008/01/02"
    And a ledger_item "Transaction 3" exists with description: "Wheat flour purchased", total_amount: -300, account: account "Bank Account", transacted_on: "2008/01/01", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    And a ledger_item "Transaction 4" exists with description: "Brown flour purchased", total_amount: -200, account: account "Bank Account", transacted_on: "2008/01/02"
    And a ledger_item "Transaction 5" exists with description: "Utility", total_amount: -150, account: account "Bank Account", transacted_on: "2008/01/03", sender: contact "Awesome Bakery", recipient: contact "Utility Co"
  }
end

Given /^I have a double entry for a flour purchase from Flour Corp$/ do
  steps %Q{
    Given a match exists
    And a ledger_item "Transaction 6" exists with total_amount: 500, account: account "Flour", transacted_on: "2008/01/01", sender: contact "Flour Corp", recipient: contact "Awesome Bakery", match: the match
    And a ledger_item "Transaction 7" exists with total_amount: -500, account: account "Bank Account", transacted_on: "2008/01/01", sender: contact "Awesome Bakery", recipient: contact "Flour Corp", match: the match
  }
end

Given /^I have conducted some business over the past year$/ do
  steps %Q{
    Given an account "Sales" exists with name: "Sales", type: "Revenue", parent: account "Revenue"
    And a contact "Owner" exists
    And a contact "Bread Retailer" exists
    And a match exists
    And a ledger_item exist with total_amount: 2000, account: account "Bank Account", transacted_on: "2008/01/01", sender: contact "Owner", recipient: contact "Awesome Bakery", match: that match
    And a ledger_item exists with total_amount: -2000, account: account "Equity", transacted_on: "2008/01/01", sender: contact "Awesome Bakery", recipient: contact "Owner", match: that match
    And a match exists
    And a ledger_item exists with total_amount: 500, account: account "Flour", transacted_on: "2008/01/15", sender: contact "Flour Corp", recipient: contact "Awesome Bakery", match: that match
    And a ledger_item exists with total_amount: -500, account: account "Bank Account", transacted_on: "2008/01/15", sender: contact "Awesome Bakery", recipient: contact "Flour Corp", match: that match
    And a match exists
    And a ledger_item exists with total_amount: 900, account: account "Bank Account", transacted_on: "2008/01/30", sender: contact "Bread Retailer", recipient: contact "Awesome Bakery", match: that match
    And a ledger_item exists with total_amount: -900, account: account "Sales", transacted_on: "2008/01/30", sender: contact "Awesome Bakery", recipient: contact "Bread Retailer", match: that match
  }
end
