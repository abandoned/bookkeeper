Then /^show me #{capture_model}$/ do |name|
  pp model(name).attributes
end

Then /^show me the (\w+) of #{capture_model}$/ do |association_name, name|
  association = model(name).send(association_name)
  if association.class == Array
    association.each { |o| pp o.attributes }
  elsif association.class.ancestors.include?(ActiveRecord::Base)
    pp association.attributes
  end
end

Then /^eval "([^"]+)"$/ do |code|
  pp instance_eval(code)
end
