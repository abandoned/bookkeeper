# == Schema Information
#
# Table name: ledger_items
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
#  ledger_account_id    :integer
#  ledger_item_group_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class LedgerItem < ActiveRecord::Base
  belongs_to :ledger_account
  belongs_to :sender, :class_name => "LedgerPerson"
  belongs_to :recipient, :class_name => "LedgerPerson"
  validates_associated :sender, :recipient, :ledger_account
  validates_presence_of :sender, :recipient, :ledger_account
  validates_numericality_of :total_amount
  validates_numericality_of :tax_amount, :allow_nil => true
  validate :must_have_a_valid_currency_code,
           :tax_may_not_exceed_total,
           :must_not_belong_to_a_ledger_account_with_children
  
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
  
  def must_not_belong_to_a_ledger_account_with_children
    if self.ledger_account && self.ledger_account.children.count > 0
      errors.add(:ledger_account, "cannot own a ledger item")
    end
  end
end