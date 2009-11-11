require 'csv'

class Import
  include Validatable
  validates_presence_of :ending_balance, :account_id, :mapping_id, :file
  attr_accessor :mapping_id, :ending_balance, :account_id, :file
  
  def initialize(params={})
    params.each{ |k, v| self.send "#{k}=", v }
  end
  
  def process
    account = Account.find(self.account_id)
    mapping = Mapping.find(self.mapping_id)
    counter = 0
    
    ledger_items = []
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
        t.total_amount = row[mapping.total_amount_row - 1].to_f * sign
        t.tax_amount = row[mapping.tax_amount_row - 1].to_f * sign unless mapping.tax_amount_row.blank?
        t.currency = mapping.currency
        
        # Descriptive entries
        t.identifier = row[mapping.identifier_row - 1] unless mapping.identifier_row.blank?
        t.description = row[mapping.description_row - 1] unless mapping.description_row.blank?
        t.description << " " + row[mapping.second_description_row - 1] unless mapping.second_description_row.blank? || row[mapping.second_description_row - 1].blank?
        
        # Some editing
        t.identifier.gsub!(/^Reference:\s/, '')
        
        # Save
        if t.valid?
          ledger_items << t
          counter += 1
        end
      end
    end
    
    # Calculate ending balance
    new_balance = account.ledger_items.sum("total_amount").to_f.round(2) + 
      ledger_items.sum { |t| t.total_amount }.to_f.round(2)
    if new_balance == self.ending_balance.to_f
      LedgerItem.import ledger_items
    else
      return 0
    end
    return mapping.has_title_row? ? counter - 1 : counter
  end
  
  def new_record?
    true
  end
    
  def self.human_name
  end
end