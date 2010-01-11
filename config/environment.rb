RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'ancestry'
  config.gem 'authlogic'
  config.gem 'chronic'
  config.gem 'compass'
  config.gem 'fastercsv'
  config.gem 'formtastic'
  config.gem 'haml'
  config.gem 'inherited_resources'
  config.gem 'jnunemaker-validatable',
             :lib => "validatable"
  config.gem 'nokogiri'
  config.gem 'responders'
  config.gem 'will_paginate'  
  
  config.time_zone = 'UTC'
end

Haml::Template.options[:format] = :html5
InheritedResources.flash_keys = [ :success, :failure ]