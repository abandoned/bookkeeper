Given /^I am logged in$/ do
  steps %Q{
    Given a user: "bookkeeper" exists with login: "bookkeeper", password: "secret"
    And I am on path "user_session/new"
    And I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "secret"
    And I press "Log in"
  }
end
  