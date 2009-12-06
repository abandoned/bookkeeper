namespace :bugs do
  desc "Remove ledger items that belong to a match that has no other ledger items"
  task :remove_duplicates => :environment do
    p Match.all.reject { |m| m.ledger_items.count > 1 }.count
  end
end