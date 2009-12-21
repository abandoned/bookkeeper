Feature: Delete matches
  In order to do proper accounting
  As a user
  I want to be able to delete erroneous matches
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Bank Account" exists with name: "Bank Account", parent: account "Assets"
    And an account "Beverages" exists with name: "Beverages", parent: account "Expenses"
    And a contact "Self" exists with name: "Self"
    And a contact "Coffee Seller" exists with name: "Coffee Seller"
    And a match exists
    And a ledger_item "L1" exists with total_amount: "-3.00", currency: "USD", account: account "Bank Account", sender: contact "Self", recipient: contact "Coffee Seller", match: the match
    And a ledger_item "L2" exists with total_amount: "3.00", currency: "USD", account: account "Beverages", sender: contact "Coffee Seller", recipient: contact "Self", match: the match
    
  Scenario: Delete match
    Given I am on path "/matches/1"
    When I follow "Delete match"
    Then I should see "Successfully deleted match."
    And a match should not exist
    And a ledger_item "L1" should exist with match_id: nil
    And a ledger_item "L2" should exist with match_id: nil
    And I should see a button called "Match"