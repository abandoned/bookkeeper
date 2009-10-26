# == Schema Information
#
# Table name: ledger_item_groups
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class LedgerItemGroup < ActiveRecord::Base
  has_many :ledger_items
  
  def reconciled?
    self.ledger_items.inject(0) { |sum, i| sum + i.total_amount } == 0 ? true : false
  end
end
