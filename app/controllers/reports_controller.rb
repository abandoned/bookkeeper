class ReportsController < ApplicationController
  before_filter :find_report_types
  
  def show
    @report_type = params[:id]
    if @report_types.include? @report_type
      @roots = Report.send @report_type.to_sym
    else
      flash.now[:failure] = 'That report does not exist'
      # TODO redirect to 404 here, instead
    end
  end
  
  private
  
  def find_report_types
    @report_types = Report::TYPES
  end
end
