namespace :fix do
  desc "Unmatch matches where ledger_items do not have same date"
  task :matches_must_have_same_date => :environment do
    Match.find_in_batches(:include => :ledger_items) do |matches|
      matches.each do |match|
        if !match.valid?
          puts match.id
          match.destroy
        end
      end
    end
  end
end
