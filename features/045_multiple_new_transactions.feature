Feature: Multiple New Transactions
  In order to do bookkeeping
  As a user
  I want to be able to enter multiple transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Create a transaction via multiple new transactions page
    Given I am on the path "/transactions"
    When I follow "Create a new transaction"
    And I follow "Multiple Entry"
    And I select "Bank Account" from "Account"
    And I select "Awesome Bakery" from "Sender"
    And I select "Flour Corp" from "Recipient"
    And I fill in "Total amount" with "-100"
    And I press "Save transactions"
    Then a ledger_item should exist with account: account "Bank Account", sender: contact "Awesome Bakery", recipient: contact "Flour Corp", total_amount: -100
  
  Scenario: New transaction fails on multiple new transactions page
    Given I am on the path "/transactions"
    When I follow "Create a new transaction"
    And I follow "Multiple Entry"
    And I select "Bank Account" from "Account"
    And I select "Awesome Bakery" from "Sender"
    And I select "Flour Corp" from "Recipient"
    And I press "Save transactions"
    Then a ledger_item should not exist