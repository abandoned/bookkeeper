desc 'Clear phantom matches'
task :clear_phantom => :environment do
  LedgerItem.matched.each { |i| i.match.destroy if i.matched_ledger_items.size == 0 } 
end
