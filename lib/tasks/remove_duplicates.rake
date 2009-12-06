namespace :bugs do
  desc "Remove ledger items that belong to a match that has no other ledger items"
  task :remove_duplicates => :environment do
    Match.all.reject { |m| m.ledger_items.count > 1 }.each do |m|
      m.ledger_items.destroy_all
      m.destroy
    end
  end
end