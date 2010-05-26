class ReportsController < ApplicationController
  before_filter :require_user

  def index
    @report_types = Report::TYPES
    @self_options = Contact.all.select{|c| c.self}.collect{ |c| [c.name, c.id.to_s] }
    
    @report_type = params[:id] || "income_statement"
    
    if @report_types.include? @report_type
      @roots = Report.send @report_type
    else
      flash.now[:failure] = 'That report does not exist'
      # TODO redirect to 404 here
    end
  end
end
