Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory.gsub(/\s/, "_"), hash)
  end
end