namespace :fix do
  desc "Match matchable foo!"
  task :match_matchables => :environment do
    credit_card_accounts = Account.find(29).subtree

    Account.find(27).subtree.each do |account|
      account.ledger_items.unmatched.each do |item|
        potential = LedgerItem.unmatched.all(:conditions => ['total_amount = ?', -1 * item.total_amount])

        # Skip credit card transactions
        potential.reject!{ |p| credit_card_accounts.any?{ |a| a == p.account } }

        # Correct date of latter transaction and match if count is one
        if potential.size == 1
          match = potential.first
          match.update_attributes!(:transacted_on => item.transacted_on)
          m = Match.create!(:ledger_items => [item, match])
          p m.id
        end
      end
    end
  end
end
