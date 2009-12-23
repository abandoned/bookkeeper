Feature: Generate Income Statement
  In order to do proper accounting
  As a bookkeeper
  I want to be able to generate income statements
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have a double entry for a beverage purchase
    And an account "Sales" exists with name: "Sales", parent: account "Revenue"
    And a contact "Other Seller" exists
    And a match "m2" exists
    And a ledger_item "Foreign Coffee" exists with total_amount: 3.00, currency: "GBP", account: account "Beverages", transacted_on: "2009/01/01", sender: contact "Coffee Vendor", recipient: contact "Self", match: match "m2"
    And a ledger_item "Foreign Purchase" exists with total_amount: -3.00, currency: "GBP", account: account "Bank Account", transacted_on: "2009/01/01", sender: contact "Self", recipient: contact "Other Seller", match: match "m2"
    And a contact "Customer" exists
    And a match "m3" exists
    And a ledger_item "Sale" exists with total_amount: -10.00, currency: "USD", account: account "Sales", transacted_on: "2009/01/02", sender: contact "Self", recipient: contact "Customer", match: match "m3"
    And a ledger_item "Income" exists with total_amount: 10.00, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/02", sender: contact "Customer", recipient: contact "Customer", match: match "m3"
  
  @wip
  Scenario: View income statement
    Given I am on path "/reports/income_statement"
    Then I should see "Income Statement" within "#main h1"
    And show me the page
    Then I should see "$10.00"
    And I should see "GBP 3.00"
    And I Should see "$ 3.00"
    And I should see "asdasd" within ".net"
    And I should see "asdasd" within ".net"