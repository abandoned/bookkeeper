namespace :fix do
  desc "Remove ledger items that belong to a match that has no other ledger items"
  task :remove_duplicates => :environment do
    Match.find(:all, :joins => 'JOIN ledger_items ON ledger_items.match_id = matches.id', :select => 'matches.id, count(1) as count_of_ledger_items', :group => 'matches.id').each do |m|
      if m.count_of_ledger_items.to_i == 1
        m.ledger_items.first.destroy
        m.destroy
      end
    end
  end
end