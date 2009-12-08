# == Schema Information
#
# Table name: ledger_items
#
#  id            :integer         not null, primary key
#  sender_id     :integer
#  recipient_id  :integer
#  transacted_on :date
#  total_amount  :decimal(, )
#  tax_amount    :decimal(, )     default(0.0)
#  currency      :string(3)       not null
#  description   :string(255)
#  identifier    :string(255)
#  account_id    :integer
#  match_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class LedgerItem < ActiveRecord::Base
  belongs_to :account
  belongs_to :match
  belongs_to :sender,     :class_name => 'Contact'
  belongs_to :recipient,  :class_name => 'Contact'
  
  validates_associated      :sender, :recipient, :account
  validates_presence_of     :account, :currency, :transacted_on
  validates_numericality_of :total_amount
  validates_numericality_of :tax_amount, :allow_nil => true
  validates_exclusion_of    :total_amount, :in => [0]
  validate                  :currency_must_validate
  validate                  :tax_amount_must_validate
  validate                  :perspective_must_validate
  
  before_create :set_transacted_on_to_today
  after_create  :create_matches
  after_update  :update_matches
  
  named_scope :matched,   :conditions => 'match_id IS NOT NULL'
  named_scope :unmatched, :conditions => 'match_id IS NULL'
  named_scope :debit,     :conditions => 'total_amount > 0'
  named_scope :credit,    :conditions => 'total_amount < 0'
  
  # These named scopes are used by the search form on the ledger items list
  named_scope :account, proc { |account|
    unless account.blank?
     { :conditions => { :account_id => account.to_i } }
    end
  }
  
  named_scope :contact, proc { |contact|
    unless contact.blank?
      if contact == '0'
        {
          :joins => 'INNER JOIN contacts AS senders ON senders.id = sender_id
                     INNER JOIN contacts AS recipients ON recipients.id = recipient_id',
          :conditions => ['senders.self = ? OR recipients.self = ?', true, true]
        }
      else
        { :conditions => ['sender_id = ? OR recipient_id = ?', contact, contact] }
      end
    end
  }
  named_scope :query, proc { |query| 
    unless query.blank?
      q = query.dup
      sql, vars = '1 = 1', []
      if query =~ /(-?[0-9]+\.[0-9]{2})/
        sql << ' AND total_amount = ?'
        vars << $1.to_f
        q.gsub!(/ ?#{$1} ?/, '')
      end
      unless q.empty?
        sql << ' AND (description LIKE ? OR identifier LIKE ?)'
        vars += 2.times.collect { "%#{q}%" }
      end
      { :conditions => [sql] + vars }
    end
  }
  named_scope :from_date, proc { |from|
    unless from.blank? || from[:year].blank?
      { :conditions => ['transacted_on >= ?', Date.new(from[:year].to_i, from[:month].to_i, from[:day].to_i)] }
    end
  }
  named_scope :to_date, proc { |to|
    unless to.blank? || to[:year].blank?
      { :conditions => ['transacted_on <= ?', Date.new(to[:year].to_i, to[:month].to_i, to[:day].to_i)] }
   end
  }
  
  def sender_name
    self.sender.name if self.sender
  end
  
  def recipient_name
    self.recipient.name if self.recipient
  end
  
  def matched?
    !self.match_id.nil?
  end
  
  def matchable?
    self.sender && self.recipient
  end
  
  def debit?
    self.total_amount > 0
  end
  
  def credit?
    self.total_amount < 0
  end
  
  def matched_ledger_items
    self.match.ledger_items.reject { |i| i.id == self.id }
  end
  
  # This curreny stuff should probably be moved out of here.
  CURRENCY_SYMBOLS = {
    'USD' => '$',
    'EUR' => '€',
    'GBP' => '£',
    'CAD' => 'C$',
    'JPY' => '¥'
  }
  
  def currency_symbol
    CURRENCY_SYMBOLS[self.currency]
  end
  
  private
  
  def set_transacted_on_to_today
    self.transacted_on = Date.today if self.transacted_on.nil?
  end
  
  def currency_must_validate
    unless ISO4217::CODE.has_key?(self.currency)
      errors.add(:currency, 'is invalid')
    end
  end
  
  def tax_amount_must_validate
    tax_amount_must_not_exceed_total_amount
    tax_amount_must_have_same_sign_as_total_amount
  end
  
  def tax_amount_must_not_exceed_total_amount
    if self.tax_amount.abs - self.total_amount.abs > 0
      errors.add(:tax_amount, 'may not exceed total amount')
    end
  end
  
  def tax_amount_must_have_same_sign_as_total_amount
    if self.tax_amount * self.total_amount < 0
      errors.add(:tax_amount, 'must have same sign as total amount')
    end
  end
  
  # If self is part of the transaction, i.e. is sender and/or recipient,
  # she should not be solely on the receiving end if transacted_amount is 
  # negative and similarly, should not be solely on the sending end if the
  # transacted amount is positive. Either case would imply we are recording 
  # in the ledger of the other party, not that of the self.
  def perspective_must_validate
    self_must_not_send_debit
    self_must_not_receive_credit
  end
    
  def self_must_not_receive_credit
    if self.credit? && self.recipient && self.recipient.self? && self.sender && !self.sender.self?
      errors.add_to_base('Not set up from perspective of self')
    end
  end
  
  def self_must_not_send_debit
    if self.debit? && self.sender && self.sender.self? && self.recipient && !self.recipient.self?
      errors.add_to_base('Not set up from perspective of self')
    end
  end
  
  def create_matches
    unless self.matched?
      self.account.rules.each do |rule|
        break if rule.match!(self)
      end
    end
  end
  
  def update_matches
    if self.matched? && self.changed? && !self.match_id_changed?
      matches = self.matched_ledger_items
      if matches.count == 1
        # Update match
        i = matches.first
        if (i.total_amount + self.total_amount).to_f.abs > 0.01 || i.sender_id != self.recipient_id || i.recipient_id != self.sender_id
          i.update_attributes(
            :total_amount   => self.total_amount * -1.0,
            :sender_id      => self.recipient_id,
            :recipient_id   => self.sender_id
          )
        end
      elsif matches.count > 1
        # Destroy matches
        self.matched_ledger_items.each { |i| i.update_attribute(:match_id, nil) }
        self.match.destroy
        self.update_attribute(:match_id, nil)
      end
    end
  end
end
