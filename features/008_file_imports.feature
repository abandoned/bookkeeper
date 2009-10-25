Feature: File Imports
  In order to keep the company ledger in order
  As a bookkeeper
  I want to be able to import files into ledger accounts
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And I have a Bank Account ledger account descending from Assets, Current Assets, Bank Accounts