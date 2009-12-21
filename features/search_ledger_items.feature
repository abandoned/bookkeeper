Feature: Search Ledger Items
  In order to do proper accounting
  As a user
  I want to be able to search ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have bought some beverages
  
  Scenario: Search by description
    Given I am on the path "/ledger_items"
    When I fill in "query" with "Coffee"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by amount
    Given I am on the path "/ledger_items"
    When I fill in "query" with "3.00"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should see "Purchase" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by description and amount
    Given I am on the path "/ledger_items"
    When I fill in "query" with "Coffee 3.00"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Purchase" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search by account type
    Given I am on the path "/ledger_items"
    When I select "Bank Account" from "account"
    And I press "Search"
    Then I should see "Purchase" within "table"
    And I should not see "Coffee" within "table"
    And I should not see "Tea" within "table"
  
  Scenario: Search unmatched only
    Given a match exists
    And a ledger_item exists with description: "Foo", match: that match
    And a ledger_item exists with description: "Bar", match: that match
    And I am on the path "/ledger_items"
    When I check "unmatched"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Foo" within "table"
  
  Scenario: Search after a date
    Given I am on the path "/ledger_items"
    When I fill in "from_date_year" with "2009"
    And I fill in "from_date_month" with "1"
    And I fill in "from_date_day" with "2"
    And I press "Search"
    Then I should see "Hot Chocolate" within "table"
    And I should see "Tea" within "table"
    And I should not see "Coffee" within "table"
  
  Scenario: Search prior to a date
    Given I am on the path "/ledger_items"
    When I fill in "to_date_year" with "2009"
    And I fill in "to_date_month" with "1"
    And I fill in "to_date_day" with "2"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should not see "Tea" within "table"
      
  Scenario: Search between two dates
    Given I am on the path "/ledger_items"
    When I fill in "from_date_year" with "2009"
    And I fill in "from_date_month" with "1"
    And I fill in "from_date_day" with "2"
    And I fill in "to_date_year" with "2009"
    And I fill in "to_date_month" with "1"
    And I fill in "to_date_day" with "3"
    And I press "Search"
    Then I should not see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should see "Tea" within "table"
    
  Scenario: Search for a particular date
    Given I am on the path "/ledger_items"
    When I fill in "from_date_year" with "2009"
    And I fill in "from_date_month" with "1"
    And I fill in "from_date_day" with "2"
    And I fill in "to_date_year" with "2009"
    And I fill in "to_date_month" with "1"
    And I fill in "to_date_day" with "2"
    And I press "Search"
    Then I should not see "Coffee" within "table"
    And I should see "Hot Chocolate" within "table"
    And I should not see "Tea" within "table"