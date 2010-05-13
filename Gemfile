source :gemcutter

gem 'aasm'
gem 'ancestry'
gem 'authlogic'
gem 'aws-s3', :require => 'aws/s3'
gem 'chronic'
gem 'compass'
gem 'delayed_job'
gem 'erubis'
gem 'fastercsv'
gem 'haml'
gem 'has_scope', '0.5.0'
gem 'inherited_resources', '1.0.6'
gem 'nokogiri'
gem 'rack', '1.0.1'
gem 'rails', '2.3.5'
gem 'responders', '0.4.7'
gem 'tzinfo'
gem 'will_paginate', '2.3.12'

group :production do
  gem 'pg'
  gem 'heroku'
  gem 'thin'
end

group :development do
  gem 'annotate'
  gem 'hirb'
end

group :development, :cucumber, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rspec-rails', '1.3.2', :require => false
end

group :cucumber, :test do
  gem 'factory_girl', '>= 1.2.4'  
end

group :cucumber do
  gem 'capybara', :require => false
  gem 'cucumber-rails', '0.3.1', :require => false
  gem 'database_cleaner', :require => false
  gem 'launchy'
  gem 'pickle', '>= 0.2.10'
end
