Given /^the ([A-Z]{3}) to EUR rate is ([0-9.]+) on "([^"]+)"$/ do |quote, rate, date|
  Factory(:exchange_rate, :currency => quote, :rate => rate.to_f, :recorded_on => date)
end
