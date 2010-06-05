Feature: Search Transactions
  In order to do bookkeeping
  As a user
  I want to search transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have bought some flour and have paid a utility bill
    And I have a double entry for a flour purchase from Flour Corp
    And I am logged in
  
  Scenario Outline: Query returns one result
    When I am on the path "/transactions"
    And I fill in "query" with "<query>"
    And I press "Search"
    Then I should see "<result>"
    And there should be <count> results
    
  Examples:
    | query                             | result      | count |
    | wheat                             | Wheat flour | 1     |
    | flour                             | Wheat flour | 2     |
    | =300                              | Wheat flour | 2     |
    | Wheat; =300                       | Wheat flour | 1     |
    | in Bank Account                   | Wheat flour | 4     |
    | not matched                       | Wheat flour | 5     |
    | since Jan 2 2008                  | Brown       | 3     |
    | until Jan 2 2008                  | Wheat       | 6     |
    | since Jan 2 2008; until 1/2/2008  | Brown       | 2     |
    | on 1/2/2008                       | Brown       | 2     |
    | until Jan 2 2008; in Bank Account | Wheat       | 3     |