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
# Indexes
#
#  index_ledger_items_on_match_id       (match_id)
#  index_ledger_items_on_description    (description)
#  index_ledger_items_on_transacted_on  (transacted_on)
#  index_ledger_items_on_total_amount   (total_amount)
#  index_ledger_items_on_sender_id      (sender_id)
#  index_ledger_items_on_recipient_id   (recipient_id)
#  index_ledger_items_on_account_id     (account_id)
#

class LedgerItem < ActiveRecord::Base
  belongs_to :account
  belongs_to :match
  belongs_to :sender,     :class_name => 'Contact'
  belongs_to :recipient,  :class_name => 'Contact'

  validates_associated      :sender, :recipient, :account
  validates_presence_of     :account, :currency, :transacted_on
  validates_numericality_of :total_amount
  validates_numericality_of :tax_amount
  validates_exclusion_of    :total_amount, :in => [0]
  validate                  :currency_must_validate
  validate                  :tax_amount_must_validate
  validate                  :perspective_must_validate

  before_validation :default_blank_tax_amount_to_0
  before_create :set_transacted_on_to_today
  after_create  :create_matches
  before_update :unmatch
  after_destroy :delete_matches

  named_scope :matched,   :conditions => 'ledger_items.match_id IS NOT NULL'
  named_scope :unmatched, :conditions => 'ledger_items.match_id IS NULL'
  named_scope :debit,     :conditions => 'ledger_items.total_amount > 0'
  named_scope :credit,    :conditions => 'ledger_items.total_amount < 0'
  named_scope :contact,   lambda { |id|
    unless id.nil?
      { :joins => 'INNER JOIN contacts AS senders ON senders.id = ledger_items.sender_id
                   INNER JOIN contacts AS recipients ON recipients.id = ledger_items.recipient_id',
        :conditions => ['senders.id = ? OR recipients.id = ?', id, id] }
    end
  }
  named_scope :from_date, lambda { |date|
    unless date.nil?
      { :conditions => ['ledger_items.transacted_on >= ?', date] }
    end
  }
  named_scope :to_date, lambda { |date|
    unless date.nil?
      { :conditions => ['ledger_items.transacted_on <= ?', date] }
    end
  }

  named_scope :perspective, lambda { |id|
    unless id.nil?
      { :joins => 'INNER JOIN contacts AS senders ON senders.id = ledger_items.sender_id
                   INNER JOIN contacts AS recipients ON recipients.id = ledger_items.recipient_id',
        :conditions => ['(senders.id = ? AND ledger_items.total_amount < 0) OR (recipients.id = ? AND ledger_items.total_amount > 0)', id, id] }
    end
  }

  def self.scope_by(query)
    scope = scoped({})
    return scope if query.blank?
    query.split(';').each do |q|
      case q.strip.upcase

      # Scope by total amount
      when /^(=|<|<=|>|>=|<>)\s*-?([0-9.,]+)$/
        scope = scope.scoped({
          :conditions => ["ABS(ledger_items.total_amount) #{$1} ?", $2.gsub(/,/, '').to_f]
        })

      # Scope by contact name
      when /^THROUGH\s+(.*)$/
        scope = scope.scoped({
          :joins => 'INNER JOIN contacts AS senders ON senders.id = ledger_items.sender_id
                     INNER JOIN contacts AS recipients ON recipients.id = ledger_items.recipient_id',
          :conditions => ['UPPER(senders.name) = ? OR UPPER(recipients.name) = ?', $1, $1]

        })

      # Scope by perspective
      when /^BY\s+(.*)$/
        scope = scope.scoped({
          :joins => 'INNER JOIN contacts AS senders ON senders.id = ledger_items.sender_id
                     INNER JOIN contacts AS recipients ON recipients.id = ledger_items.recipient_id',
          :conditions => ['(UPPER(senders.name) = ? AND ledger_items.total_amount < 0) OR (UPPER(recipients.name) = ? AND ledger_items.total_amount > 0)', $1, $1]
        })

      # Scope by account name
      when /^IN\s+(.*)$/
        scope = scope.scoped({
          :include => [:account],
          :conditions => ['UPPER(accounts.name) = ?', $1]
        })

      # Scope by date
      when /^ON\s+(.*)$/
        date = Chronic.parse($1)
        if date
          scope = scope.scoped({
            :conditions => ['ledger_items.transacted_on = ?', date.to_date]
          })
        end

      # Scope by start date
      when /^SINCE\s+(.*)$/
        date = Chronic.parse($1)
        if date
          scope = scope.scoped({
            :conditions => ['ledger_items.transacted_on >= ?', date.to_date]
          })
        end

      # Scope by end date
      when /^UNTIL\s+(.*)$/
        date = Chronic.parse($1)
        if date
          scope = scope.scoped({
            :conditions => ['ledger_items.transacted_on <= ?', date.to_date]
          })
        end

      # Scope by match status
      when /^\s*NOT MATCHED\s*$/
        scope = scope.scoped({
          :conditions => 'ledger_items.match_id IS NULL'
        })

      when /^\s*MATCHED\s*$/
        scope = scope.scoped({
          :conditions => 'ledger_items.match_id IS NOT NULL'
        })

      # Scope by description
      when /\w/
        if RAILS_ENV == "production"
          scope = scope.scoped({
            :conditions => ['ledger_items.description ILIKE ?', "%#{q}%"]
          })
        else
          scope = scope.scoped({
            :conditions => ['UPPER(ledger_items.description) LIKE ?', "%#{q.upcase}%"]
          })
        end
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

  # The contact from whose perspective the ledger item is transacted
  def self_contact
    credit? ? sender : recipient
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
    if sender.present? && recipient.present? && !self_contact.self?
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

  def unmatch
    if self.matched? && self.changed? && !self.match_id_changed?
      match.destroy
    end
  end

  def delete_matches
    if self.matched?
      match.destroy
    end
  end

  def default_blank_tax_amount_to_0
    if tax_amount.blank?
      self.tax_amount = 0
    end
  end
end
