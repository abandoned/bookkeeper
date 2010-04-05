Feature: Import Transactions
  In order to add ledger items quickly
  As a bookkeeper
  I want to be able to import them from a CSV file
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "AMEX" exists with name: "AMEX", parent: account "Liabilities"
      And an account "Citi" exists with name: "Citi", parent: asset "Assets"
      And a ledger_item "Opening Balance" exists with total_amount: "1047.98", currency: "USD", account: account "Citi", transacted_on: "12/10/2008"
      And the following mappings exist
        | name     | currency | date_row | total_amount_row | description_row | second_description_row | has_title_row | day_follows_month | reverses_sign |
        | Amex, UK | GBP      | 1        | 3                | 4               |                        | false         | false             | true          |
        | Amex, US | USD      | 1        | 5                | 2               | 4                      | true          | true              | true          |
        | Citi     | USD      | 1        | 3                | 2               |                        | false         | true              | false         |
  
  Scenario: List imports
    Given 10 imports exist with account: account "AMEX", mapping: that mapping
    And I am on the path "/transactions"
    And I follow "Import"
    Then I should see "pending"
    
  Scenario: Import a CSV
    Given I am on the path "/transactions"
    When I follow "Import"
    And I follow "Import new file"
    And I fill in "Ending balance" with "6587.42"
    And I select "AMEX" from "Account"
    And I select "Amex, UK" from "Mapping"
    And I attach the file "spec/fixtures/amex-uk-sample.csv" to "File"
    And I press "Import transactions"
    Then I should see "pending"
    And I should see "amex-uk-sample.csv"
    When the system processes jobs
    And I am on the path "/imports"
    Then I should see "265 transactions imported"