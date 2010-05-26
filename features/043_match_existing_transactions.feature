Feature: Match Existing Ledger Items
  In order to do bookkeeping
  As a user
  I want to be reconcile by matching existing transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Match two ledger items and reconcile
    Given I have bought some flour and have paid a utility bill
    When I go to path "/transactions"
    And I follow "Match" within "#ledger_item_1"
    And I follow "Match" within "#ledger_item_3"
    And I follow "Save match"
    Then I should see "Transactions successfully reconciled"
    And a match should exist
    And ledger_item "Transaction 1" should exist with match: that match
    And ledger_item "Transaction 2" should exist with match: that match
      
  Scenario: Match three ledger items and reconcile
    Given a ledger_item "t1" exists with id: 10, total_amount: -4.00, account: account "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    And a ledger_item "t2" exists with id: 11, total_amount: 2.00, account: account "Flour", sender: contact "Flour Corp", recipient: contact "Awesome Bakery"
    And a ledger_item "t3" exists with id: 12, total_amount: 2.00, account: account "Flour", sender: contact "Flour Corp", recipient: contact "Awesome Bakery"
    When I go to path "/transactions"
    And I follow "Match" within "#ledger_item_10"
    And I follow "Match" within "#ledger_item_11"
    And I follow "Match" within "#ledger_item_12"
    And I follow "Save match"
    Then a match should exist
    And ledger_item "t1" should exist with match: that match
    And ledger_item "t2" should exist with match: that match
    And ledger_item "t3" should exist with match: that match
    