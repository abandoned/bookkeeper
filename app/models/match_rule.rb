# == Schema Information
#
# Table name: match_rules
#
#  id                         :integer         not null, primary key
#  sender_id                  :integer
#  recipient_id               :integer
#  ledger_account_id          :integer
#  matching_ledger_account_id :integer
#  description_matcher        :string(255)
#  debit                      :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

class MatchRule < ActiveRecord::Base
  belongs_to :ledger_account
  belongs_to :sender, :class_name => "LedgerPerson"
  belongs_to :recipient, :class_name => "LedgerPerson"
  belongs_to :matching_ledger_account, :class_name => "LedgerAccount"
  validates_associated :sender, :recipient, :ledger_account, :matching_ledger_account
  validates_presence_of :sender, :recipient, :ledger_account, :matching_ledger_account
  after_save :match_items
  
  def match_items
    self.ledger_account.ledger_items.unmatched.each { |i| self.match(i) }
  end
  
  def match(item)
    mlt = self.debit? ? 1 : -1
    regexp = Regexp.new(self.description_matcher, true)
    if !item.matched? && item.description =~ regexp && item.total_amount * mlt > 0
      matched_item = LedgerItem.create!(:sender_id => self.recipient_id,
                                        :recipient_id => self.sender_id,
                                        :issued_on => item.issued_on,
                                        :total_amount => item.total_amount * -1.0,
                                        :currency => item.currency,
                                        :ledger_account_id => self.matching_ledger_account_id)
      group = LedgerItemGroup.create!
      group.ledger_items << [item, matched_item]
      item.update_attributes!(:sender_id => self.sender_id,
                              :recipient_id => self.recipient_id)
    else
      false
    end
  end
end
