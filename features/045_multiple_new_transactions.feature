@wip
Feature: Multiple New Transactions
  In order to do bookkeeping
  As a user
  I want to be able to enter multiple transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
  
  Scenario: Create multiple transactions
    Given I am on the path "/transactions"
    When I follow "Create transaction"
    And I follow "Switch to multiple entry"