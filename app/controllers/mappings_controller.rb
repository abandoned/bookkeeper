class MappingsController < InheritedResources::Base
  before_filter :require_user
end
