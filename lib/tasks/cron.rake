task :cron => :environment do
  Rake::Task['backup'].execute
  Rake::Task['fixer:download:current'].execute
end