Then /^I should download$/ do |output|
  page.source.should == output
end
