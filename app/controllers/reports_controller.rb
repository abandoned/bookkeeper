class ReportsController < ApplicationController
  before_filter :require_user
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
  
  def calculate_totals
    @totals = {}
    end_of_association_chain.sum(:total_amount, :group => :currency).each_pair do |currency, total_amount|
      @totals[LedgerItem::CURRENCY_SYMBOLS[currency]] = total_amount.round(2)
    end
  end
end
