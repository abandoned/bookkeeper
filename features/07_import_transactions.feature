Feature: Import Transactions
  In order to add ledger items quickly
  As a bookkeeper
  I want to be able to import them from a CSV file
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "AMEX" exists with name: "AMEX", parent: account "Liabilities"
      And an account "Citi" exists with name: "Citi", parent: account "Assets"
      And a ledger_item "Opening Balance" exists with total_amount: "1047.98", currency: "USD", account: account "Citi", transacted_on: "12/10/2008"
      And the following mappings exist
        | name     | currency | date_row | total_amount_row | description_row | second_description_row | has_title_row | day_follows_month | reverses_sign |
        | Amex, UK | GBP      | 1        | 3                | 4               |                        | false         | false             | true          |
        | Amex, US | USD      | 1        | 5                | 2               | 4                      | true          | true              | true          |
        | Citi     | USD      | 1        | 3                | 2               |                        | false         | true              | false         |
  
  Scenario: Import a CSV with a correct Ending balance
    Given I am on the show page for account "AMEX"
    When I follow "Import transactions"
    And I select "AMEX" from "Account"
    And I fill in "Ending balance" with "6587.42"
    And I select "Amex, UK" from "Mapping"
    And I attach the file "spec/fixtures/amex-uk-sample.csv" to "File"
    And I press "Import transactions"
    Then I should see "265 ledger items imported"
      
  Scenario: Attempt to import a CSV with an incorrect Ending balance
    Given I am on the show page for account "AMEX"
    When I follow "Import transactions"
    And I fill in "Ending balance" with "0"
    And I select "Amex, UK" from "Mapping"
    And I attach the file "spec/fixtures/amex-uk-sample.csv" to "File"
    And I press "Import transactions"
    Then I should see "Import failed"
    And I should see "Ending balance of 6587.42 did not match expected balance of 0"
    
  Scenario: Import a CSV with no identifier row and with thousand separators in numbers
    Given I am on the show page for account "AMEX"
    When I follow "Import transactions"
      And I fill in "Ending balance" with "7886.55"
      And I select "Amex, US" from "Mapping"
      And I attach the file "spec/fixtures/amex-us-sample.csv" to "File"
      And I press "Import transactions"
    Then I should see "197 ledger items imported"
  
  Scenario: Import a Citi statement into an account with opening balance
    Given I am on the show page for account: "Citi"
    When I follow "Import transactions"
      And I fill in "Ending balance" with "20475.49"
      And I select "Citi" from "Mapping"
      And I attach the file "spec/fixtures/citi-sample.csv" to "File"
      And I press "Import transactions"
    Then I should see "51 ledger items imported"