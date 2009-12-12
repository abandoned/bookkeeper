Feature: Delete matches
  In order to do proper accounting
  As a user
  I want to be able to delete erroneous matches
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
    And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
    And a contact "Self" exists with name: "Self"
    And a contact "Starbux" exists with name: "Starbux"
    And a match exists
    And a ledger_item "L1" exists with total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", match: the match
    And a ledger_item "L2" exists with total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
    
  Scenario: Delete match
    Given I am on path "/matches/1"
    When I follow "Delete match"
    Then I should see "Successfully deleted match."
    And a match should not exist
    And a ledger_item "L1" should exist with match_id: nil
    And a ledger_item "L2" should exist with match_id: nil
    And I should see a button called "Match"