Feature: Export in CSV format
  In order to do proper accounting
  As a user
  I want to be able to export ledger items in CSV format
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Petty Cash" exists with name: "Petty Cash", parent: account "Assets"
    And an account "Beverages" exists with name: "Beverages", parent: account "Expenses"
    And a match exists
    And a ledger_item exists with description: "Coffee", total_amount: "2", currency: "USD", account: account "Beverages", transacted_on: "1/1/2009", match: the match
    And a ledger_item exists with description: "Hot Chocolate", total_amount: "1.50", currency: "USD", account: account "Beverages", transacted_on: "1/2/2009"
    And a ledger_item exists with description: "Tea", total_amount: "2.59", currency: "USD", account: account "Beverages", transacted_on: "1/3/2009", match: the match
  
  Scenario: Export entire ledger
    Given I am on the path "/ledger_items"
    When I follow "Export"
    Then I should download
    """
    transacted_on,currency,total_amount,tax_amount,description,sender_name,recipient_name
    2009-01-01,USD,2.0,0.0,Coffee,,
    2009-01-02,USD,1.5,0.0,Hot Chocolate,,
    2009-01-03,USD,2.59,0.0,Tea,,
    
    """
  
  Scenario: Export a search
    Given I am on the path "/ledger_items"
    When I fill in "query" with "Coffee"
    And I press "Search"
    Then I should see "Coffee" within "table"
    And I should not see "Tea" within "table"
    When I follow "Export"
    Then I should download
    """
    transacted_on,currency,total_amount,tax_amount,description,sender_name,recipient_name
    2009-01-01,USD,2.0,0.0,Coffee,,
    
    """
    