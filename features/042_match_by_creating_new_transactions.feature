Feature: Match by Creating a New Transaction
  In order to do bookkeeping
  As a user
  I want to reconcile a transaction by by creating a matching new one
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Create a matching item to balance the cart
    Given I have bought some flour and have paid a utility bill
    When I go to path "/transactions"
    And I press "Match" within "#ledger_item_5"
    And I select "Utility" from "ledger_item_account_id"
    When I press "Create match"
    Then I should see "Transaction successfully reconciled"
    And I should not see "Matches"
    And a match should exist

  @wip
  Scenario: Can't create match when there is more than one transaction in the cart
    Given a ledger_item exists with total_amount: "1", account: account "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    And a ledger_item exists with total_amount: "1", account: account "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    When I go to path "/transactions"
    And I press "Match" within "#ledger_item_1"
    And I press "Match" within "#ledger_item_2"
    Then I should not see /form/ within "#cart"
