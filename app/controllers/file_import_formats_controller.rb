class FileImportFormatsController < InheritedResources::Base
  before_filter :require_user
  respond_to :html
end
