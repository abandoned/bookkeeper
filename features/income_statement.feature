Feature: Generate Income Statement
  In order to do proper accounting
  As a bookkeeper
  I want to be able to generate income statements
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have a double entry for a beverage purchase
    And a contact "Other Seller" exists with name: "Other Seller"
    And a match exists
    And a ledger_item "Foreign Coffee" exists with description: "Foreign Coffee", total_amount: 3.00, currency: "GBP", account: account "Beverages", transacted_on: "2009/01/01", sender: contact "Coffee Vendor", recipient: contact "Self", match: the match
    And a ledger_item "Foreign Purchase" exists with description: "Purchase", total_amount: -3.00, currency: "GBP", account: account "Bank Account", transacted_on: "2009/01/01", sender: contact "Self", recipient: contact "Other Seller", match: the match
  
  Scenario: View income statement
    Given I am on path "/reports/income_statement"
    Then I should see "Income Statement" within "#main h1"
    #Then I should see "97.01" within "#net_income"