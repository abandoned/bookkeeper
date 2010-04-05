class ReportsController < ApplicationController
  before_filter :require_user
  before_filter :find_report_types
  
  def show
    @self_options = Contact.all.select{|c| c.self}.collect{ |c| [c.name, c.id.to_s] }
    
    @report_type = params[:id]
    if @report_types.include? @report_type
      @roots = Report.send @report_type
    else
      flash.now[:failure] = 'That report does not exist'
      # TODO redirect to 404 here
    end
  end
  
  private
  
  def find_report_types
    @report_types = Report::TYPES
  end
end
