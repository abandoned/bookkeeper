RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'compass', :version => '>= 0.10.0'
  config.gem 'haml', :version => '>=3.0.0'
  config.time_zone = 'UTC'
end

Haml::Template.options[:format] = :html5
InheritedResources.flash_keys = [ :success, :failure ]