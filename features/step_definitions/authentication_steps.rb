Given /^I am logged in$/ do
  steps %Q{
    Given a user: "bookkeeper" exists with login: "bookkeeper"
    And I am on the home page
    When I follow "Log in"
    And I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "secret"
    And I press "Log in"
    Then I should be on path "/transactions"
  }
end
  