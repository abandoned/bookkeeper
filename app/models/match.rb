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

  validate :should_be_reconciled
  validate :should_have_same_currency
  validate :should_have_same_date
  validate :should_have_same_self

  before_destroy :unmatch_ledger_items

  def reconciled?
    ledger_items.inject(0) { |sum, i| sum + i.total_amount } == 0 ? true : false
  end

  def create_balancing_item(account)
    if ledger_items.size > 1
      raise ArgumentError
    end

    current_item = self.ledger_items.first
    new_item = current_item.clone

    new_item.sender, new_item.recipient =
      current_item.recipient, current_item.sender
    new_item.total_amount, new_item.tax_amount =
      -current_item.total_amount, -current_item.tax_amount
    new_item.account = account
    new_item.match = self

    ledger_items << new_item

    new_item
  end

  private

  def should_be_reconciled
    errors.add_to_base('Must be reconciled') unless self.reconciled?
  end

  def should_have_same_currency
    currencies = ledger_items.inject([]) { |m, i| m << i.currency unless m.include?(i.currency); m }
    errors.add_to_base('Transactions must have same currency') if currencies.size > 1
  end

  def should_have_same_date
    dates = ledger_items.inject([]) { |m, i| m << i.transacted_on; m }
    errors.add_to_base('Transactions must have same date') if dates.uniq.size > 1
  end

  def should_have_same_self
    if ledger_items.map(&:self_contact).uniq.size != 1
      errors.add_to_base("Transactions must have same self")
    end
  end

  def unmatch_ledger_items
    ledger_items.each { |i| i.update_attribute(:match_id, nil) }
  end
end
