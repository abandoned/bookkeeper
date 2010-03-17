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
  named_scope :contact,   lambda { |id|
    unless id.nil?
      { :joins => 'INNER JOIN contacts AS senders ON senders.id = sender_id
                   INNER JOIN contacts AS recipients ON recipients.id = recipient_id',
        :conditions => ['senders.id = ? OR recipients.id = ?', id, id] }
    end
  }
  named_scope :from_date, lambda { |date|
    { :conditions => ['transacted_on >= ?', date] }
  }
  named_scope :to_date, lambda { |date|
    { :conditions => ['transacted_on <= ?', date] }
  }
  
  def self.scope_by(query)
    scope = scoped({})
    return scope if query.blank?
    query.split(';').each do |q|
      case q.strip.upcase
        
      # Scope by total amount
      when /^(=|<|<=|>|>=|<>)\s*-?([0-9.,]+)$/
        scope = scope.scoped({
          :conditions => ["ABS(total_amount) #{$1} ?", $2.gsub(/,/, '').to_f]
        })
      
      # Scope by contact name
      when /^BY\s+(.*)$/
        scope = scope.scoped({
          :joins => 'INNER JOIN contacts AS senders ON senders.id = sender_id
                     INNER JOIN contacts AS recipients ON recipients.id = recipient_id',
          :conditions => ['UPPER(senders.name) = ? OR UPPER(recipients.name) = ?', $1, $1] 
        })
      
      # Scope by account name
      when /^IN\s+(.*)$/
        scope = scope.scoped({
          :include => [:account],
          :conditions => ['UPPER(accounts.name) = ?', $1]
        })
      # Scope by date
      when /^ON\s+(.*)$/
        date = Chronic.parse($1).to_date
        if date
          scope = scope.scoped({
            :conditions => ['transacted_on = ?', date]
          })
        end
        
      # Scope by start date
      when /^SINCE\s+(.*)$/
        date = Chronic.parse($1).to_date
        if date
          scope = scope.scoped({
            :conditions => ['transacted_on >= ?', date]
          })
        end
      
      # Scope by end date
      when /^UNTIL\s+(.*)$/
        date = Chronic.parse($1).to_date
        if date
          scope = scope.scoped({
            :conditions => ['transacted_on <= ?', date]
          })
        end
      
      # Scope by match status
      when /^\s*NOT MATCHED\s*$/
        scope = scope.scoped({
          :conditions => 'match_id IS NULL'
        })
      
      when /^\s*MATCHED\s*$/
        scope = scope.scoped({
          :conditions => 'match_id IS NOT NULL'
        })
      
      # Scope by description
      when /\w/
        scope = scope.scoped({
          :conditions => ['UPPER(description) LIKE ?', "%#{q}%"]
        })
      end
    end
    
    scope
  end  
  
  def account_name
    self.account.name if self.account
  end
  
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
  
  def matches
    self.match.ledger_items.reject { |i| i.id == self.id }
  end
  
  # TODO Refactor these out of here.
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
    if self.credit? &&
       self.recipient &&
       self.recipient.self? &&
       self.sender &&
       !self.sender.self?
      errors.add_to_base('Not set up from perspective of self')
    end
  end
  
  def self_must_not_send_debit
    if self.debit? &&
       self.sender && 
       self.sender.self? && 
       self.recipient && 
       !self.recipient.self?
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
      matches = self.matches
      if matches.size == 1
        
        # Update match
        i = matches.first
        if (i.total_amount + self.total_amount).to_f.abs > 0.01 || 
            i.sender_id != self.recipient_id ||
            i.recipient_id != self.sender_id
          i.update_attributes(
            :total_amount   => self.total_amount * -1.0,
            :sender_id      => self.recipient_id,
            :recipient_id   => self.sender_id
          )
        end
      elsif matches.size > 1
        
        # Destroy matches
        self.matches.each { |i| i.update_attribute(:match_id, nil) }
        self.match.destroy
        self.update_attribute(:match_id, nil)
      end
    end
  end
end
