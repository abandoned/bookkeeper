# == Schema Information
#
# Table name: rules
#
#  id                  :integer         not null, primary key
#  sender_id           :integer
#  recipient_id        :integer
#  account_id          :integer
#  matching_account_id :integer
#  regexp              :string(255)
#  debit               :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class Rule < ActiveRecord::Base
  belongs_to :account
  belongs_to :sender, :class_name => "Contact"
  belongs_to :recipient, :class_name => "Contact"
  belongs_to :matching_account, :class_name => "Account"
  validates_associated :sender, :recipient, :account, :matching_account
  validates_presence_of :sender, :recipient, :account, :matching_account, :regexp
  after_save :match_ledger_items
  
  def match_ledger_items
    self.account.ledger_items.unmatched.each { |i| self.match!(i) }
  end
  
  def match!(ledger_item)
    mlt = self.debit? ? 1 : -1
    regexp = Regexp.new(self.regexp, true)
    if !ledger_item.matched? && ledger_item.description =~ regexp && ledger_item.total_amount * mlt > 0
      matched_ledger_item = LedgerItem.create!(:sender_id => self.recipient_id,
                                        :recipient_id => self.sender_id,
                                        :transacted_on => ledger_item.transacted_on,
                                        :total_amount => ledger_item.total_amount * -1.0,
                                        :currency => ledger_item.currency,
                                        :account_id => self.matching_account_id)
      group = Match.create!
      group.ledger_items << [ledger_item, matched_ledger_item]
      ledger_item.update_attributes!(:sender_id => self.sender_id,
                              :recipient_id => self.recipient_id)
    else
      false
    end
  end
end
