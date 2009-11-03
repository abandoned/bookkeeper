class RulesController < InheritedResources::Base
  before_filter :require_user
  belongs_to :account
  respond_to :html
end
