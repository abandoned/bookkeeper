at_exit do
  system("sleep 3 && rm #{Rails.root}/capybara-* 2> /dev/null &")
end
