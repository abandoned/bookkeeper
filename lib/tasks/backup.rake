desc 'Capture bundle of a Heroku app'
task :backup => :environment do
  bundler = HerokuBundler.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'], ENV['APP_NAME'])
  bundler.capture
end