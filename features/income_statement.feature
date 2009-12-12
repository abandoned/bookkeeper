Feature: Generate Income Statement
  In order to do proper accounting
  As a bookkeeper
  I want to be able to generate income statements
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And an account "Sales" exists with name: "Sales", parent: account "Revenue"
      And a contact "Self" exists with name: "Self"
      And a contact "Starbux" exists with name: "Starbux"
      And a contact "Customer" exists with name: "Customer"
      And a match "m1" exists
      And a ledger_item exists with total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", match: match "m1"
      And a ledger_item exists with total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: match "m1"
      And a match "m2" exists
      And a ledger_item exists with total_amount: "100", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Customer", match: match "m2"
      And a ledger_item exists with total_amount: "-100", currency: "USD", account: account "Sales", sender: contact "Customer", recipient: contact "Self", match: match "m2"
  
  Scenario: View income statement
    Given I am on path "/reports/income_statement"
    Then I should see "Income Statement" within "#main h1"
    #Then I should see "97.01" within "#net_income"