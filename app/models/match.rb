# == Schema Information
#
# Table name: matches
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Match < ActiveRecord::Base
  has_many :ledger_items
  accepts_nested_attributes_for :ledger_items
  validate :must_be_reconciled
  
  def reconciled?
    self.ledger_items.inject(0) { |sum, i| sum + i.total_amount } == 0 ? true : false
  end
  
  protected
  
  def must_be_reconciled
    errors.add_to_base("Must be reconciled") unless self.reconciled?
  end
end