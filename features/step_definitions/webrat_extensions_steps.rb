When /^(?:|I )press "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  within(parent) do
    click_button(button)
  end
end

Then /^I should see a button called "([^\"]*)"$/ do |button|
  response.should have_selector("input[type='submit']", :value => button)
end

Then /^I should not see a button called "([^\"]*)"$/ do |button|
  response.should_not have_selector("input[type='submit']", :value => button)
end

Then /^I should see a button called "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  response.should have_selector("#{parent} input[type='submit']", :value => button)
end

Then /^I should not see a button called "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  response.should_not have_selector("#{parent} input[type='submit']", :value => button)
end

Then /^I should download$/ do |output|
  response_body.should == output
end
