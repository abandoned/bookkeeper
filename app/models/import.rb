# == Schema Information
#
# Table name: imports
#
#  id         :integer         not null, primary key
#  account_id :integer
#  file_name  :string(255)
#  message    :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  mapping_id :integer
#

class Import < ActiveRecord::Base
  include AASM
  
  belongs_to :account
  belongs_to :mapping
  
  validates_presence_of :account, :mapping, :file, :ending_balance
  
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
  
  def copy_temp_file
    self.copied_file_path = "/tmp/#{Time.now.to_i}.csv"
    system("cp #{file.path} #{copied_file_path}")
  end
  
  def perform
    first_line = true
    @ledger_items = []
    
    FasterCSV.foreach(copied_file_path) do |row|
      
      # Skip first if title col
      if first_line
        first_line = false
        next if mapping.has_title_row?
      end
      
      # Sign
      sign = mapping.reverses_sign? ? -1 : 1
      
      t = LedgerItem.new(:account => account)
      
      # Format date
      if mapping.day_follows_month?
        t.transacted_on = row[mapping.date_row - 1]
      else
        t.transacted_on = Date.strptime(row[mapping.date_row - 1], '%d/%m/%Y')
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
    ending_balance_confirmation = @account.ledger_items.sum("total_amount").to_f.round(2) + @ledger_items.sum { |t| t.total_amount }.to_f.round(2)
    
    if (ending_balance.to_f - ending_balance_confirmation.to_f).abs  < 0.01
      ActiveRecord::Base.transaction do
        @ledger_items.each { |i| i.save! }
      end
      self.message = "#{transaction_count} transactions imported"
      succeed!
    else
      self.message = "Ending balance of #{ending_balance_confirmation} did not match expected balance of #{ending_balance}"
      fail!
    end
  end
  
  def transaction_count
    @ledger_items.size
  end
end
