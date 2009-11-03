# == Schema Information
#
# Table name: transactions
#
#  id                   :integer         not null, primary key
#  sender_id            :integer
#  recipient_id         :integer
#  issued_on            :date
#  total_amount         :decimal(20, 4)
#  tax_amount           :decimal(20, 4)
#  currency             :string(3)       not null
#  description          :string(255)
#  identifier           :string(255)
#  account_id    :integer
#  match_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :sender, :class_name => "Person"
  belongs_to :recipient, :class_name => "Person"
  belongs_to :match
  validates_associated :sender, :recipient, :account
  validates_presence_of :account, :currency
  validates_numericality_of :total_amount
  validates_numericality_of :tax_amount, :allow_nil => true
  validate :must_have_a_valid_currency_code,
           :tax_may_not_exceed_total
  named_scope :matched, :conditions => "match_id IS NOT NULL"
  named_scope :unmatched, :conditions => "match_id IS NULL"
  
  # These are the short-hand named scopes used the search form
  named_scope :account, proc { |account|
    unless account.blank?
     { :conditions => { :account_id => account.to_i } }
    end
  }
  named_scope :person, proc { |person|
    unless person.blank?
      { :conditions => ["sender_id = ? OR recipient_id = ?", person, person] }
    end
  }
  named_scope :query, proc { |query| 
    unless query.blank?
      q = query.dup
      sql, vars = "1", []
      if query =~ /(-?[0-9]+\.[0-9]{2})/ || q =~ /(-?[0-9]+)(\s|$)/
        sql << " AND total_amount = ?"
        vars << $1.to_f
        q.gsub!(/ ?#{$1} ?/, "")
      end
      unless q.empty?
        sql << " AND (description LIKE ? OR identifier LIKE ?)"
        vars << "%#{q}%"
        vars << "%#{q}%"
        p ([sql] + vars).inspect
      end
      { :conditions => [sql] + vars }
    end
  }
  named_scope :matched, proc { |matched|
    if matched == 1
      { :conditions => "match_id IS NULL" }
    end
  }
  named_scope :from, proc { |from|
    if from.blank? || from[:year].blank?
      { :conditions => ["issue_date > ?", Date.new(from[:year].to_i, from[:month].to_i, from[:day].to_i)] }
    end
  }
  named_scope :to, proc { |to|
    unless to.blank? || to[:year].blank?
      { :conditions => ["issue_date > ?", Date.new(to[:year].to_i, to[:month].to_i, to[:day].to_i)] }
   end
  }
  
  CURRENCY_SYMBOLS = { "USD" => "$", "EUR" => "€", "GBP" => "£", "CAD" => "CAD$", "JPY" => "¥"}
  
  def matched?
    !self.match_id.nil?
  end
  
  # This probably should be factored out of here.
  def currency_symbol
    CURRENCY_SYMBOLS[self.currency]
  end
  
  protected
  
  def must_have_a_valid_currency_code
    unless ISO4217::CODE.has_key?(self.currency)
      errors.add(:currency, "is invalid")
    end
  end
  
  def tax_may_not_exceed_total
    if !self.tax_amount.nil? && self.tax_amount > self.total_amount
      errors.add(:tax_amount, "may not exceed total amount")
    end
  end
end