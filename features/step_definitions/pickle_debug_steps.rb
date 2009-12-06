Then /^inspect #{capture_model}$/ do |name|
  p model(name).inspect
  
end

Then /^inspect the (\w+) of #{capture_model}$/ do |association, name|
  p model(name).send(association).inspect
end