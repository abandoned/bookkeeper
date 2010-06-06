class ReportsController < ApplicationController
  before_filter :require_user

  def show
    @report = Report.new(params)
  end
end
