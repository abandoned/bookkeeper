Feature: Manage Ledger Items
  In order to keep the company in order
  As a bookkeeper
  I want to be able to create and manage ledger items
  
  Background:
    Given I am logged in as bookkeeper
    And I have a default ledger set up
    And I have a Current Assets account descending from Assets
    And I have a Bank Accounts account descending from Current Assets
    And I have a Bank Account account descending from Bank Accounts
    And I have a Shipping Expenses account descending from Expenses
    And the following person records:
      | name                | is_self |
      | Paper Cavalier | true   |
      | US Postal Service   | false   |
    
  Scenario: Create a new credit entry under the Citibank account
    Given I am on the list of ledger_items
    And I follow "New ledger item"
    And I select "Bank Account" from "Account"
    And I select "January 1, 2009" as the date
    And I select "Paper Cavalier" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "USD" from "Currency"
    And I fill in "Total Amount" with "-20"
    And I fill in "Description" with "US Postal Service charge"
    And I press "Submit"
    Then I should see "US Postal Service charge"
    And I should see "Bank Account"
    And I should see "-20.0"
    
  Scenario: View ledger ledger items for a date range
    
  