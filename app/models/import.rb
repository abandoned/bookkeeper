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
#

class Import < ActiveRecord::Base
  include AASM
  
  belongs_to :account
  
  include Validatable
  validates_presence_of :ending_balance, :account_id, :mapping_id, :file, :groups => [:processing]
  validates_each :ending_balance_confirmation, :groups => [:importing],
                 :logic => lambda {
                   unless (ending_balance.to_f - ending_balance_confirmation.to_f).abs  < 0.01
                     errors.add(:ending_balance, "of #{ending_balance_confirmation} did not match expected balance of #{ending_balance}")
                   end
                  }
  attr_accessor :ledger_items, :mapping_id, :ending_balance, :ending_balance_confirmation, :account_id, :file
  
  aasm_column         :status
  aasm_initial_state  :pending
  aasm_state          :pending
  aasm_state          :completed
  
  aasm_event :complete do
    transitions :to => :completed, :from => [:pending]
  end
  
  def XXXXinitialize(params={})
    params.each{ |k, v| self.send "#{k}=", v }
    self.ledger_items = []
  end
  
  def process
    account = Account.find(self.account_id)
    mapping = Mapping.find(self.mapping_id)
    counter = 0
    
    data = self.file.read
    data.each_line do |line|
    
      # Skip first if title row
      if counter == 0 && mapping.has_title_row?
        counter += 1
        next
      end
      
      # Sign
      sign = mapping.reverses_sign? ? -1 : 1
        
      CSV.parse line do |row|
        t = LedgerItem.new(:account_id => self.account_id)
        
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
        t.description = row[mapping.description_row - 1] unless mapping.description_row.blank?
        t.description << " " + row[mapping.second_description_row - 1] unless mapping.second_description_row.blank? || row[mapping.second_description_row - 1].blank?
                
        # Save
        if t.valid?
          ledger_items << t
          counter += 1
        end
      end
    end
    
    # Calculate ending balance
    self.ending_balance_confirmation = account.ledger_items.sum("total_amount").to_f.round(2) + 
      ledger_items.sum { |t| t.total_amount }.to_f.round(2)
  end
  
  def import
    ActiveRecord::Base.transaction do
      ledger_items.each { |i| i.save! }
    end
    return ledger_items.size
  end
end
