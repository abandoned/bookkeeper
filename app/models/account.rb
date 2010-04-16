# == Schema Information
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#
# Indexes
#
#  index_accounts_on_type      (type)
#  index_accounts_on_ancestry  (ancestry)
#

class Account < ActiveRecord::Base
  has_ancestry  :orphan_strategy => :restrict
  has_many      :imports
  has_many      :ledger_items
  has_many      :rules
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  before_destroy :cannot_orphan_ledger_items
  
  def all_ledger_items
    self.subtree.inject([]) { |m, a| m + a.ledger_items }
  end
  
  def total_for(contact=nil,since=nil,till=nil)
    @total ||= calculate_total_for(self, contact, since, till)
  end
  
  def total_for?(contact=nil,since=nil,till=nil)
    !total_for(contact, since, till).blank?
  end
    
  def grand_total_for(contact=nil,since=nil,till=nil)
    @grand_total ||= self.subtree.inject({}) do |grand_total, account| 
      calculate_total_for(account, contact, since, till, grand_total)
    end
  end
  
  def grand_total_for?(contact=nil,since=nil,till=nil)
    !grand_total_for(contact, since, till).blank?
  end
  
  def currency_symbol
    @currency_symbol ||= self.subtree.each { |a| a.ledger_items.each { |i| return i.currency_symbol } }
  end
  
  # http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
  class <<self
    alias_method :real_model_name, :model_name
  end
  
  def self.model_name
    name = 'account'
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
    end
    name
  end
  
  private
  
  def cannot_orphan_ledger_items
    raise ActiveRecord::RecordNotDestroyed if self.ledger_items.size > 0
  end
  
  def calculate_total_for(account,contact,since,till,total={})
    account.ledger_items.contact(contact).from_date(since).to_date(till).sum(:total_amount, :group => :currency).each_pair do |currency, total_amount|
      if total[LedgerItem::CURRENCY_SYMBOLS[currency]].blank?
        total[LedgerItem::CURRENCY_SYMBOLS[currency]] = total_amount.round(2)
      else
        total[LedgerItem::CURRENCY_SYMBOLS[currency]] += total_amount.round(2)
      end
    end
    total
  end
end

class Asset < Account; end
class Liability < Account; end
class Revenue < Account; end
class Expense < Account; end
class Equity < Account; end

