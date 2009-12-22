Feature: Export in CSV format
  In order to do proper accounting
  As a user
  I want to be able to export ledger items in CSV format
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have a double entry for a beverage purchase
    And a ledger_item exists with description: "Hot Chocolate", total_amount: "1.50", currency: "USD", account: account "Beverages", transacted_on: "1/2/2009"
  
  @wip @tag
  Scenario: Export entire ledger
    Given I am on the path "/ledger_items"
    When I follow "Export"
    Then I should download
    """
    transacted on,account,currency,total amount,tax amount,description,sender,recipient,match
    2009-01-01,Beverages,USD,2.0,0.0,Coffee,Coffee Vendor,Self,Bank Account
    2009-01-01,Bank Account,USD,1.5,0.0,Purchase,Bank Account,Coffee Vendor,Self,Beverages
    2009-01-02,Beverages,USD,2.59,0.0,Hot Chocolate,Beverages,,,
    
    """
  
  @wip
  Scenario: Export a search
    Given I am on the path "/ledger_items"
    When I fill in "query" with "Coffee"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Tea" within "table"
    When I follow "Export"
    Then I should download
    """
    transacted on,account,currency,total amount,tax amount,description,sender,recipient,match
    2009-01-01,USD,2.0,0.0,Coffee,Beverages,,
    
    """
    