Feature: Search Transactions
  In order to take care of my accounting needs
  As a user
  I want to be able to search ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have bought some beverages
    And I am on the path "/transactions"
  
  Scenario: Search by description
    When I fill in "query" with "Coffee"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by amount
    When I fill in "query" with "=3.00"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should see "Purchase" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by description and amount
    When I fill in "query" with "Coffee, = 3.00"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Purchase" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by account type
    When I fill in "query" with "in Bank Account"
    And I press "Search"
    Then I should see "Purchase" within "table"
    And I should not see "Coffee" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search unmatched only
    Given a match exists
    And a ledger_item exists with description: "Foo", match: that match
    And a ledger_item exists with description: "Bar", match: that match
    When I fill in "query" with "not matched"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Foo" within "table"
  
  Scenario: Search after a date
    When I fill in "query" with "since Jan 2 2009"
    And I press "Search"
    Then I should see "Hot Chocolate" within "table"
    And I should see "Tea" within "table"
    And I should not see "Coffee" within "table"
  
  Scenario: Search prior to a date
    When I fill in "query" with "until Jan 2 2009"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should not see "Tea" within "table"
      
  Scenario: Search between two dates
    When I fill in "query" with "since Jan 2 2009, until 1/3/2009"
    And I press "Search"
    Then I should not see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should see "Tea" within "table"
    
  Scenario: Search for a particular date
    When I fill in "query" with "on 1/2/2009"
    And I press "Search"
    Then I should not see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should not see "Tea" within "table"