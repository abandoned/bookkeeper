Feature: Generate Income Statement
  In order to keep the company in order
  As a bookkeeper
  I want to be able to generate income statements
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Bank A/C" exists with name: "Bank A/C", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And an account "Sales" exists with name: "Sales", parent: account "Revenue"
      And a person "Self" exists with name: "Self"
      And a person "Starbucks" exists with name: "Starbucks"
      And a person "Customer" exists with name: "Customer"
      And a match "m1" exists
      And a ledger_item exists with total_amount: "-2.99", currency: "USD", account: account "Bank A/C", sender: person "Self", recipient: person "Starbucks", match: match "m1"
      And a ledger_item exists with total_amount: "2.99", currency: "USD", account: account "Coffee", sender: person "Starbucks", recipient: person "Self", match: match "m1"
      And a match "m2" exists
      And a ledger_item exists with total_amount: "100", currency: "USD", account: account "Bank A/C", sender: person "Self", recipient: person "Customer", match: match "m2"
      And a ledger_item exists with total_amount: "-100", currency: "USD", account: account "Sales", sender: person "Customer", recipient: person "Self", match: match "m2"
  
  Scenario: View income statement
    Given I am on path "/reports/income_statement"
    Then I should see "97.01" within "#net_income"