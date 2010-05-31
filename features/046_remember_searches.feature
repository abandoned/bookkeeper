Feature: Search Transactions
  In order to do bookkeeping
  As a user
  I want to search transactions

  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have bought some flour and have paid a utility bill
    And I have a double entry for a flour purchase from Flour Corp
    And I am logged in

  Scenario: Site should remember transaction queries
    When I am on the path "/transactions"
    And I fill in "query" with "wheat"
    And I press "Search"
    And I go to the path "/contacts"
    And I go to the path "/transactions"
    Then the "query" field should contain "wheat"
