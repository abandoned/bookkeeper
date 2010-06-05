class ReportsController < ApplicationController
  before_filter :require_user

  def show
    @self_select_options = Contact.self.collect{ |c| [c.name, c.id.to_s] }

    if params[:base_currency].nil?
      params[:contact] = @self_select_options.first.last
      params[:base_currency] = 'USD'
      params[:from_date] = Date.ordinal(Date.today.year - 1, 1)
      params[:to_date] = Date.ordinal(Date.today.year - 1, 365)
    end

    @report = Report.new(params[:id].titleize)
  end
end
