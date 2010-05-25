RAILS_GEM_VERSION = '2.3.7' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
end

Haml::Template.options[:format] = :html5
