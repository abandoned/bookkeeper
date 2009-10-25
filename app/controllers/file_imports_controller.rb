class FileImportsController < ApplicationController
  before_filter :require_user
  before_filter :find_ledger_account
  
  def new
    @file_import = FileImport.new
  end

  def create
    require 'csv'
    @errors = []
    @ledger_account.name =~ / ([0-9]+)$/
    if params[:import][:file] && params[:import][:file].original_filename !~ /#{$1}/
      @errors << "File name does not contain account number"
    end
    @errors << "Select a file" if params[:import][:file].nil?
    @errors << "Select an import format" if params[:import][:import_format].empty?
    if @errors.empty?
      format = LedgerImportFormat.find(params[:import][:import_format])
      n = 0
      data = params[:import][:file].read
      date_check = nil
      data.each_line do |line|
        if n == 0 && format.has_title?
          n += 1
          next
        end
        Payment.transaction do
          CSV.parse line do |row|
            t = Payment.new
            if format.day_follows_month
              t.issue_date = row[format.date_row - 1]
            else
              t.issue_date = Date.strptime(row[format.date_row - 1], '%d/%m/%Y')
            end
            t.total_amount = row[format.amount_row - 1]
            if t.issue_date.nil? || t.total_amount.to_f == 0.0
              next
            end
            t.identifier = row[format.identifier_row - 1] unless format.identifier_row.nil?
            t.description = ""
            format.description_row.split(",").each do |number|
              number = number.to_i - 1
              t.description << " " unless t.description.blank? || row[number].blank?
              t.description << row[number] unless row[number].blank?
            end
            if date_check != t.issue_date
              ledger_items_on_same_day = @ledger_account.ledger_items.find(:first, :conditions => ["DATE(issue_date) = ?", t.issue_date])
              unless ledger_items_on_same_day.blank?
                next
              else
                date_check = t.issue_date
              end
            end
            t.currency = @ledger_account.currency unless @ledger_account.currency.nil?
            t.status = "cleared"
            @ledger_account.ledger_items << t
            t.save!
            n += 1
          end
        end
      end
      n -= 1 if format.has_title
      flash[:notice]="#{n} new records added"
      redirect_to ledger_account_items_url(@ledger_account)
    end
  end
  
  protected
  
  def find_ledger_account
    @ledger_account = LedgerAccount.find(params[:ledger_account_id])
  end
end
