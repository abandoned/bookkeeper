task :cron => :environment do
  Rake::Task['backup'].execute
end