desc 'Bootstrap the app environment'
task :bootstrap => [:environment, 'db:schema:load', 'db:seed'] do
  Bootstrapper.bootstrap!
end