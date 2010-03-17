Feature: Export transactions
  In order to do bookkeeping
  As a user
  I want to export transactions in CSV format
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have bought some flour and have paid a utility bill
    And I have a double entry for a flour purchase from Flour Corp
    And I am logged in
  
  Scenario: Export entire ledger
    Given I am on the path "/transactions"
    When I follow "Export"
    Then I should download
    """
    transacted on,account,currency,total amount,tax amount,description,sender,recipient,match
    2008-01-01,Flour,USD,300.0,0.0,,Flour Corp,Awesome Bakery,
    2008-01-01,Bank Account,USD,-300.0,0.0,Wheat flour purchased,Awesome Bakery,Flour Corp,
    2008-01-01,Flour,USD,500.0,0.0,,Flour Corp,Awesome Bakery,Bank Account
    2008-01-01,Bank Account,USD,-500.0,0.0,,Awesome Bakery,Flour Corp,Flour
    2008-01-02,Flour,USD,200.0,0.0,,,,
    2008-01-02,Bank Account,USD,-200.0,0.0,Brown flour purchased,,,
    2008-01-03,Bank Account,USD,-150.0,0.0,Utility,Awesome Bakery,Utility Co,

    """
  
  Scenario: Export a search
    Given I am on the path "/transactions"
    When I fill in "query" with "flour"
    And I press "Search"
    And I follow "Export"
    Then I should download
    """
    transacted on,account,currency,total amount,tax amount,description,sender,recipient,match
    2008-01-01,Bank Account,USD,-300.0,0.0,Wheat flour purchased,Awesome Bakery,Flour Corp,
    2008-01-02,Bank Account,USD,-200.0,0.0,Brown flour purchased,,,
    
    """
  
  Scenario: Export an account
    Given I am on the path "/transactions"
    When I fill in "query" with "in Flour"
    And I press "Search"
    And I follow "Export"
    Then I should download
    """
    transacted on,account,currency,total amount,tax amount,description,sender,recipient,match
    2008-01-01,Flour,USD,300.0,0.0,,Flour Corp,Awesome Bakery,
    2008-01-01,Flour,USD,500.0,0.0,,Flour Corp,Awesome Bakery,Bank Account
    2008-01-02,Flour,USD,200.0,0.0,,,,

    """
  