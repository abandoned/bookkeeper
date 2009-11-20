# == Schema Information
#
# Table name: ledger_items
#
#  id           :integer         not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  transacted_on    :date
#  total_amount :decimal(20, 4)
#  tax_amount   :decimal(20, 4)
#  currency     :string(3)       not null
#  description  :string(255)
#  identifier   :string(255)
#  account_id   :integer
#  match_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class LedgerItem < ActiveRecord::Base
  belongs_to :account
  belongs_to :sender, :class_name => "Contact"
  belongs_to :recipient, :class_name => "Contact"
  belongs_to :match
  
  validates_associated      :sender, :recipient, :account
  validates_presence_of     :account, :currency, :transacted_on
  validates_numericality_of :total_amount
  validates_numericality_of :tax_amount, :allow_nil => true
  validate :must_have_valid_currency_code,
           :tax_may_not_exceed_total,
           :tax_may_not_have_inverse_sign_of_total
  
  before_update :prevent_edit_of_total_amount_after_reconciliation
  after_save    :find_matches!
  
  named_scope :matched, :conditions => "match_id IS NOT NULL"
  named_scope :unmatched, :conditions => "match_id IS NULL"
  
  # These are the short-hand named scopes used the search form
  named_scope :account, proc { |account|
    unless account.blank?
     { :conditions => { :account_id => account.to_i } }
    end
  }
  named_scope :contact, proc { |contact|
    unless contact.blank?
      if contact == "All selves"
        {
          :joins => "INNER JOIN contacts AS senders ON senders.id = sender_id INNER JOIN contacts AS recipients ON recipients.id = recipient_id",
          :conditions => ["senders.is_self = ? OR recipients.is_self = ?", true, true]
        }
      else
        { :conditions => ["sender_id = ? OR recipient_id = ?", contact, contact] }
      end
    end
  }
  named_scope :query, proc { |query| 
    unless query.blank?
      q = query.dup
      sql, vars = "TRUE", []
      if query =~ /(-?[0-9]+\.[0-9]{2})/ || q =~ /(-?[0-9]+)(\s|$)/
        sql << " AND total_amount = ?"
        vars << $1.to_f
        q.gsub!(/ ?#{$1} ?/, "")
      end
      unless q.empty?
        sql << " AND (description LIKE ? OR identifier LIKE ?)"
        vars << "%#{q}%"
        vars << "%#{q}%"
      end
      { :conditions => [sql] + vars }
    end
  }
  named_scope :matched, proc { |matched|
    if matched == 1
      { :conditions => "match_id IS NULL" }
    end
  }
  named_scope :from_date, proc { |from|
    unless from.blank? || from[:year].blank?
      { :conditions => ["transacted_on >= ?", Date.new(from[:year].to_i, from[:month].to_i, from[:day].to_i)] }
    end
  }
  named_scope :to_date, proc { |to|
    unless to.blank? || to[:year].blank?
      { :conditions => ["transacted_on <= ?", Date.new(to[:year].to_i, to[:month].to_i, to[:day].to_i)] }
   end
  }
  
  def matched?
    !self.match_id.nil?
  end
  
  def matchable?
    self.sender && self.recipient
  end
  
  # Curreny stuff probably be moved out of here.
  CURRENCY_SYMBOLS = { "USD" => "$", "EUR" => "€", "GBP" => "£", "CAD" => "CAD$", "JPY" => "¥"}
  
  def currency_symbol
    CURRENCY_SYMBOLS[self.currency]
  end
  
  private
  
  def must_have_valid_currency_code
    unless ISO4217::CODE.has_key?(self.currency)
      errors.add(:currency, "is invalid")
    end
  end
  
  def tax_may_not_exceed_total
    if self.tax_amount.abs > self.total_amount.abs
      errors.add(:tax_amount, "may not exceed total amount")
    end
  end
  
  def tax_may_not_have_inverse_sign_of_total
    if self.tax_amount * self.total_amount < 0
      errors.add(:tax_amount, "may not have inverse sign of total amount")
    end
  end
  
  # We don't want find_matches! to trigger this hook. Hence, the last condition
  def prevent_edit_of_total_amount_after_reconciliation
    if self.matched? && self.total_amount_changed? && !self.match_id_changed?
      raise ActiveRecord::RecordNotSaved, "Cannot edit total amount after reconciliation"
    end
  end
  
  def find_matches!
    unless self.matched?
      self.account.rules.each do |rule|
        break if rule.match!(self)
      end
    end
  end
end
