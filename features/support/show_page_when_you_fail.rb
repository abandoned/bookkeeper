After("@verbose") do |scenario|
  if scenario.status == :failed
    save_and_open_page
  end
end
