# These are temporary tasks to clear bugs, refactor existing data, and so on.
# Should delete them after a while.

namespace :refactor do
  # Clears phantom matches (which should never have come into existence
  # in the first place!)
  task :dephantom => :environment do
    Match.all.each do |m|
      case m.ledger_items.count
      when 0
        m.destroy
      when 1
        m.ledger_items.first.update_attribute(:match_id, nil)
        m.destroy
      end
    end
  end
end