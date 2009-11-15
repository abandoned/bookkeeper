Feature: Import Ledger Items
  In order to add ledger items quickly
  As a bookkeeper
  I want to be able to import them from a CSV file
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    Given an account "AMEX" exists with name: "AMEX", parent: account "Liabilities"
    And the following mappings exist
      | name     | currency | date_row | total_amount_row | description_row | identifier_row | has_title_row | day_follows_month | reverses_sign |
      | Amex, UK | GBP      | 1        | 3                | 4               | 2              | false         | false             | true          |
  
  Scenario: Attempt to import a CSV with an incorrect ending balance
    Given I am on path "/ledger_items"
    When I follow "Import Ledger Items"
    And I select "AMEX" from "Account"
    And I fill in "Ending Balance" with "0"
    And I select "Amex, UK" from "Mapping"
    And I attach the file at "spec/fixtures/amex-uk-sample.csv" to "File"
    And I press "Upload file"
    Then I should see "Import failed"
    And I should see "Ending balance of 2323.7 did not match expected balance of 0"

  Scenario: Attempt to import a CSV with an incorrect ending balance
    Given I am on path "/ledger_items"
    When I follow "Import Ledger Items"
    And I select "AMEX" from "Account"
    And I fill in "Ending Balance" with "2323.7"
    And I select "Amex, UK" from "Mapping"
    And I attach the file at "spec/fixtures/amex-uk-sample.csv" to "File"
    And I press "Upload file"
    Then I should see "1784 ledger items imported"
