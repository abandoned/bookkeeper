When /^(?:|I )press "([^\"]*)" within "([^\"]*)"$/ do |button, parent|
  within(parent) do
    click_button(button)
  end
end