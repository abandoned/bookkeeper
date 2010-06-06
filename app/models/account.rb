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
  has_many      :imports, :dependent => :destroy
  has_many      :ledger_items
  has_many      :rules, :dependent => :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name

  before_destroy :cannot_orphan_ledger_items
  after_destroy  :destroy_associated_rules

  def all_ledger_items
    self.subtree.inject([]) { |m, a| m + a.ledger_items }
  end

  # Return the sum of the total amounts of the ledger items in an account. Optionally,
  # filter by contact or date range. Returns an array of totals, grouped by currency.
  def total_for(contact=nil,from_date=nil,to_date=nil)
    @total ||= calculate_total_for(self, contact, from_date, to_date)
  end

  def total_for_in_base_currency(contact=nil,from_date=nil,to_date=nil,base_currency='USD')
    @total_in_base_currency ||=
      total_for(contact, from_date, to_date).sum do |currency, value|
        value * ExchangeRate.historical(currency, base_currency, to_date || Date.today)
      end
  end

  def total_for?(contact=nil,from_date=nil,to_date=nil)
    !total_for(contact, from_date, to_date).blank?
  end

  def grand_total_for(contact=nil,from_date=nil,to_date=nil)
    @grand_total ||= self.subtree.inject({}) do |grand_total, account|

      calculate_total_for(account, contact, from_date, to_date, grand_total)
    end
  end

  def grand_total_for_in_base_currency(contact=nil,from_date=nil,to_date=nil,base_currency='USD')
    @grand_total_in_base_currency ||=
      grand_total_for(contact, from_date, to_date).sum do |currency, value|
        value * ExchangeRate.historical(currency, base_currency, to_date || Date.today)
      end
  end

  def grand_total_for?(contact=nil,from_date=nil,to_date=nil)
    !grand_total_for(contact, from_date, to_date).blank?
  end

  def currency_symbol
    @currency_symbol ||= self.subtree.each { |a| a.ledger_items.each { |i| return i.currency_symbol } }
  end

  class <<self
    # http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
    alias_method :real_model_name, :model_name

    def model_name
      name = 'account'
      name.instance_eval do
        def plural;   pluralize;   end
        def singular; singularize; end
      end
      name
    end
  end

  private

  def cannot_orphan_ledger_items
    raise ActiveRecord::RecordNotDestroyed if self.ledger_items.size > 0
  end

  def calculate_total_for(account,contact,from_date,to_date,total={})
    account.ledger_items.matched.perspective(contact.to_i).from_date(from_date).to_date(to_date).sum(:total_amount, :group => :currency).each_pair do |currency, total_amount|
      if total[currency].blank?
        total[currency] = total_amount.round(2)
      else
        total[currency] += total_amount.round(2)
      end
    end
    total
  end

  def destroy_associated_rules
    Rule.destroy_all(:new_account_id => id)
  end
end
