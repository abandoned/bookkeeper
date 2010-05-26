class MappingsController < InheritedResources::Base
  before_filter :require_user
  actions :all, :except => :show

  def create
    create! { mappings_path }
  end

  def update
    update! { mappings_path }
  end

  private

  def collection
    @mappings ||= end_of_association_chain.paginate(
      :page   => params[:page])
  end
end
