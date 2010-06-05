class ReportsController < ApplicationController
  before_filter :require_user

  def index
    
    
    
    
    if @report_types.include? @report_type
      @roots = Report.send @report_type
    else
      flash.now[:failure] = 'That report does not exist'
      # TODO redirect to 404 here
    end
  end

  def show
    @report = Report.new(params[:id].titleize)

    @self_select_options = Contact.self.collect{ |c| [c.name, c.id.to_s] }
  end
end
