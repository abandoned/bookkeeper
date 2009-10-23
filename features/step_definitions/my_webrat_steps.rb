Then /^the "([^\"]*)" select list should have option "([^\"]*)"$/ do |field, value|
  field_labeled(field).element.to_s.gsub(/&nbsp;/, "").should =~ />#{value}<\/option>/i
end

Then /^the "([^\"]*)" select list should not have option "([^\"]*)"$/ do |field, value|
  field_labeled(field).element.to_s.gsub(/&nbsp;/, "").should_not =~ />#{value}<\/option>/i
end