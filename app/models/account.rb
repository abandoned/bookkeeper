# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  acts_as_tree :orphan_strategy => :restrict
  has_many :ledger_items
  has_many :rules
  validates_uniqueness_of :name
  validates_presence_of :name
  before_destroy :do_not_orphan_ledger_items
  
  def total
    @total ||= self.ledger_items.sum('total_amount')
  end
  
  def total?
    total != 0
  end
    
  def grand_total
    @grand_total ||= self.subtree.inject(nil) { |sum, a| sum ? sum + a.ledger_items.sum('total_amount') : a.ledger_items.sum('total_amount') }
  end
  
  def grand_total?
    grand_total != 0
  end
  
  def currency_symbol
    @currency_symbol ||= self.subtree.each { |a| a.ledger_items.each { |i| return i.currency_symbol } }
  end
  
  protected
  
  def do_not_orphan_ledger_items
    raise ActiveRecord::RecordNotDestroyed if self.ledger_items.size > 0
  end
end
