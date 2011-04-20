RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require 'thread'
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
end

Haml::Template.options[:format] = :html5

InheritedResources.flash_keys = [ :notice, :error ]
