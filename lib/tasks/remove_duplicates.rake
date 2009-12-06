namespace :bugs do
  desc "Remove ledger items that belong to a match that has no other ledger items"
  task :remove_duplicates => :environment do
    Match.all.each do |m|
      if m.ledger_items.count == 1
        m.ledger_items.destroy_all
        m.destroy
      end
    end
  end
end