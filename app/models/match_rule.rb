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
  after_save :match!
  
  def match!
    multiplier = self.debit? ? 1 : -1
    self.ledger_account.ledger_items.unmatched.each do |i|
      if i.description =~ /#{self.description_matcher}/i && i.total_amount * multiplier > 0
        i.sender_id = self.sender_id
        i.recipient_id = self.recipient_id
        i.save!
        m = LedgerItem.create!(:sender_id => i.recipient_id,
                               :recipient_id => i.sender_id,
                               :issued_on => i.issued_on,
                               :total_amount => i.total_amount * -1.0,
                               :currency => i.currency,
                               :ledger_account_id => self.matching_ledger_account_id)
        group = LedgerItemGroup.create!
        group.ledger_items << [i, m]
      end
    end
  end
end
