Feature: Match Recorded Transactions
  In order to do bookkeeping
  As a user
  I want to be able to reconcile by matching recorded transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: When I edit a matched transaction, its match should update as well
    Given I have a double entry for a flour purchase from Flour Corp
    And a contact "Organic Flour" exists with name: "Organic Flour"
    When I go to the show page for ledger_item "Transaction 6"
    And I follow "Edit"
    And I fill in "Total amount" with "1000"
    And I select "Organic Flour" from "Sender"
    And I press "Update transaction"
    Then I should see "Successfully updated transaction"
    And ledger_item "Transaction 6" should exist with total_amount: 1000, sender: contact "Organic Flour"
    And a match should exist

  Scenario: When I edit a transaction posted against two other transactions, the match should be deleted
     Given a match exists
     And a ledger_item "l1" exists with total_amount: -2, asset: asset "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp", match: the match
     And a ledger_item "l2" exists with total_amount: 1, expense: expense "Flour", sender: contact "Flour Corp", recipient: contact "Awesome Bakery", match: the match
     And a ledger_item "l3" exists with total_amount: 1, expense: expense "Flour", sender: contact "Flour Corp", recipient: contact "Awesome Bakery", match: the match
     When I go to path "/transactions/1/edit"
     And I fill in "Total amount" with "10"
     And I select "Flour Corp" from "Sender"
     And I select "Awesome Bakery" from "Recipient"
     And I press "Update transaction"
     Then the match should not exist
     And ledger_item "l1" should not be matched
     And ledger_item "l2" should not be matched
     And ledger_item "l3" should not be matched
     And I should see "Successfully updated transaction"