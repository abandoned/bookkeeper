class MatchesController < InheritedResources::Base
  before_filter :require_user
  respond_to :html
  actions :show
end
