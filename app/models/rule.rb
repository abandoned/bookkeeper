# == Schema Information
#
# Table name: rules
#
#  id                   :integer         not null, primary key
#  new_sender_id        :integer
#  new_recipient_id     :integer
#  account_id           :integer
#  new_account_id       :integer
#  matched_description  :string(255)
#  matched_debit        :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  matched_sender_id    :integer
#  matched_recipient_id :integer
#



class Rule < ActiveRecord::Base
  belongs_to :account
  belongs_to :new_account,        :class_name => "Account"
  belongs_to :new_sender,         :class_name => "Contact"
  belongs_to :new_recipient,      :class_name => "Contact"
  belongs_to :matched_sender,     :class_name => "Contact"
  belongs_to :matched_recipient,  :class_name => "Contact"
  
  validates_associated    :new_sender, :new_recipient, :matched_sender, :matched_recipient, :account, :new_account
  validates_presence_of   :account, :new_account
  validates_inclusion_of  :matched_debit, :in => [true, false]
  
  validate  :must_have_at_least_one_matcher,
            :must_either_match_or_assign_contacts
  
  after_save :apply_to_ledger
  
  def apply_to_ledger
    self.account.ledger_items.unmatched.send( self.matched_debit ? :debit : :credit).each { |i| self.match!(i) }
  end
  
  def match!(ledger_item)
    # Match sign
    if ledger_item.total_amount * (self.matched_debit? ? 1 : -1) < 0
      return false
    end
    
    # Match description
    unless self.matched_description.nil? || (!self.matched_sender_id.nil? && !self.matched_recipient_id.nil?)
      regexp = Regexp.new(self.matched_description, true)
      unless ledger_item.description =~ regexp
        return false
      end
    end
    
    # Match sender
    unless self.matched_sender_id.nil?
      unless ledger_item.sender_id == self.matched_sender_id
        return false
      end
    end
    
    # Match recipient
    unless self.matched_recipient_id.nil?
      unless ledger_item.recipient_id == self.matched_recipient_id
        return false
      end
    end
    
    # Populate contacts
    ledger_item.sender_id = self.new_sender_id if ledger_item.sender_id.nil?
    ledger_item.recipient_id = self.new_recipient_id if ledger_item.recipient_id.nil?
    
    # Create matching ledger item
    new_ledger_item = LedgerItem.new(
      :transacted_on  => ledger_item.transacted_on,
      :total_amount   => ledger_item.total_amount * -1.0,
      :currency       => ledger_item.currency,
      :account_id     => self.new_account_id,
      :sender_id      => ledger_item.recipient_id,
      :recipient_id   => ledger_item.sender_id
    )
    
    # Create match and save ledger items
    match = Match.create!
    [ledger_item, new_ledger_item].each do |i|
      i.match_id = match.id
      i.save!
    end
  end
  
  private
  
  def must_have_at_least_one_matcher
    if self.matched_description.blank? && self.matched_sender_id.nil? && self.matched_recipient_id.nil?
      errors.add_to_base('Rule must have at least one matcher')
    end
  end
  
  def must_either_match_or_assign_contacts
    unless (self.matched_sender_id.nil? ^ self.new_sender_id.nil?) && (self.matched_recipient_id.nil? ^ self.new_recipient_id.nil?)
      errors.add_to_base('Rule must either match or assign contacts')
    end
  end
end
