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
  
  def total_for(contact=0)
    @total ||= calculate_total_for(self, contact)
  end
  
  def total_for?(contact=0)
    !total_for(contact).blank?
  end
    
  def grand_total_for(contact=0)
    @grand_total ||= self.subtree.inject({}) do |grand_total, account| 
      calculate_total_for(account, contact, grand_total)
    end
  end
  
  def grand_total_for?(contact=0)
    !grand_total_for(contact).blank?
  end
  
  def currency_symbol
    @currency_symbol ||= self.subtree.each { |a| a.ledger_items.each { |i| return i.currency_symbol } }
  end
  
  private
  
  def do_not_orphan_ledger_items
    raise ActiveRecord::RecordNotDestroyed if self.ledger_items.size > 0
  end
  
  def calculate_total_for(account,contact,total={})
    account.ledger_items.contact(contact).from_date(Date.new(2006, 8, 1)).to_date(Date.new(2006, 8, 31)).sum(:total_amount, :group => :currency).each_pair do |currency, total_amount|
      if total[LedgerItem::CURRENCY_SYMBOLS[currency]].blank?
        total[LedgerItem::CURRENCY_SYMBOLS[currency]] = total_amount.round(2)
      else
        total[LedgerItem::CURRENCY_SYMBOLS[currency]] += total_amount.round(2)
      end
    end
    total
  end
    
end
