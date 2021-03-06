# == Schema Information
#
# Table name: imports
#
#  id             :integer         not null, primary key
#  account_id     :integer
#  file_name      :string(255)
#  message        :string(255)
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  mapping_id     :integer
#  ending_balance :decimal(20, 4)
#

class Import < ActiveRecord::Base
  include AASM
  
  belongs_to :account
  belongs_to :mapping
  
  validates_presence_of :account, :mapping, :file, :ending_balance
  validates_numericality_of :ending_balance
  
  attr_accessor :file, :copied_file_path
  
  aasm_column         :status
  aasm_initial_state  :pending
  aasm_state          :pending
  aasm_state          :processed
  aasm_state          :failed
  
  aasm_event :succeed do
    transitions :to => :processed, :from => [:pending]
  end
  
  aasm_event :fail do
    transitions :to => :failed, :from => [:pending]
  end
  
  def parse_file
    @parsable = file.read
  end
  
  def perform
    begin
      first_line = true
      @ledger_items = []
      
      # Sign
      sign = mapping.reverses_sign? ? -1 : 1
      
      FasterCSV.parse(@parsable) do |row|
        
        # Skip first if title col
        if first_line
          first_line = false
          next if mapping.has_title_row?
        end
        
        t = LedgerItem.new(:account => account)
        
        date_string = row[mapping.date_row - 1]
        
        # Convert two-digit years to four digits
        if date_string.match(/(\W)(\d{2})$/)
          date_string.gsub!(/#{$1}#{$2}$/, $1 + '20' + $2)
        end
        
        if mapping.day_follows_month?
          t.transacted_on = date_string
        else
          
          # Added this block to handle inconsistent dates in manually created CSVs. Should probably
          # refactor this mess at some point.
          begin
            t.transacted_on = Date.strptime(date_string, '%d/%m/%Y')
          rescue
            self.message = "Dates not consistent"
            fail!
            return
          end
        end
        
        # Money entries
        t.total_amount = row[mapping.total_amount_row - 1].gsub(/[^0-9.-]/, '').to_f * sign
        t.tax_amount = row[mapping.tax_amount_row - 1].gsub(/[^0-9.-]/, '').to_f * sign unless mapping.tax_amount_row.blank?
        t.currency = mapping.currency
        
        # Descriptive entries
        unless mapping.description_row.blank?
          t.description = row[mapping.description_row - 1]
        end
        unless mapping.second_description_row.blank? || row[mapping.second_description_row - 1].blank?
          t.description << " " + row[mapping.second_description_row - 1]
        end
        
        @ledger_items << t if t.valid?
      end
    
      # Calculate ending balance
      total_in_csv = @ledger_items.sum { |t| t.total_amount }.to_f.round(2)
      ending_balance_confirmation = @account.ledger_items.sum("total_amount").to_f.round(2) + total_in_csv
    
      if (ending_balance.to_f - ending_balance_confirmation.to_f).abs  < 0.01
        ActiveRecord::Base.transaction do
          @ledger_items.each { |i| i.save! }
        end
        self.message = "#{transaction_count} transactions imported"
        succeed!
      else
        self.message = "Ending balance of #{ending_balance_confirmation} did not match expected balance of #{ending_balance} (#{total_in_csv})"
        fail!
      end
    rescue Exception => e  
      self.message = (e.message + e.backtrace.inspect)[0,100]
      fail!
    end
  end
  
  def transaction_count
    @ledger_items.size
  end
end
