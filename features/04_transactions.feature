Feature: Transactions
  In order to do bookkeeping
  As a user
  I want to be able to manage transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Create a transaction
    Given I am on the path "/transactions"
    When I follow "Create transaction"
    And I select "Bank Account" from "Account"
    And I select "Awesome Bakery" from "Sender"
    And I select "Flour Corp" from "Recipient"
    And I fill in "Total amount" with "-100"
    And I press "Create transaction"
    Then a ledger_item should exist with asset: asset "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp", total_amount: -100
  
  Scenario: Edit a transaction
    Given I have bought some flour and have paid a utility bill
    And I am on the show page for ledger_item: ledger_item "Transaction 1"
    When I follow "Edit"
    And I fill in "Total amount" with "50"
    And I press "Update transaction"
    Then ledger_item "Transaction 1" should exist with total_amount: 50