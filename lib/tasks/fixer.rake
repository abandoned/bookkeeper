namespace :fixer do
  namespace :download do
    desc 'Download current rates'
    task :current, :needs => [:environment] do
      EcbFeed.download_daily
    end

    namespace :history do
      desc 'Fetch 90-day history'
      task :ninety_days, :needs => [:environment] do
        EcbFeed.download_90_days
      end

      desc 'Fetch all history'
      task :all, :needs => [:environment] do
        EcbFeed.download_all
      end
    end
  end
end
