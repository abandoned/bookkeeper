Feature: Match Recorded Transactions
  In order to do bookkeeping
  As a user
  I want to be able to reconcile by matching recorded transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: When I edit a matched transaction, it should be unmatched
    Given I have a double entry for a flour purchase from Flour Corp
    And a contact "Organic Flour" exists with name: "Organic Flour"
    When I go to the show page for ledger_item "Transaction 6"
    And I follow "Edit"
    And I fill in "Total amount" with "1000"
    And I press "Update transaction"
    Then I should see "Successfully updated transaction"
    And ledger_item "Transaction 6" should exist with total_amount: 1000, match_id: nil
    And ledger_item "Transaction 7" should exist with total_amount: -500, match_id: nil
    And a match should not exist
