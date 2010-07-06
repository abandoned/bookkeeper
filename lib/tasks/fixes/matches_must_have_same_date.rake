namespace :fix do
  desc "Unmatch invalid matches"
  task :matches_must_validate => :environment do
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
